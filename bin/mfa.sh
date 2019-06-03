#!/bin/sh
#
# Script to login using MFA to AWS via the CLI
#

findMfaDevice() {
  username=$1

  # Get MFA devices
  mfaDevices=$(aws iam list-mfa-devices --user-name $username) 2> /dev/null

  if [[ "$(echo $mfaDevices | jq '.MFADevices |length')" == 1 ]]; then
    mfaSerialNumber=$(echo $mfaDevices | jq -r '.MFADevices[0].SerialNumber')
  else
    echo "None or multiple MFA devices found: $mfaDevices" >&2
    exit 1
  fi
}

mfaLogin() {
  username=$1
  token=$2

  findMfaDevice $username

  if [[ ! -z $mfaSerialNumber ]]; then
    awsSessionToken=$(aws sts get-session-token --serial-number $mfaSerialNumber --token-code $token)
  fi
}


if [[ -z $1 || -z $2 ]]; then
  printf "%s\n" "Usage: ${0##*/} <user name> <mfa token>" >&2
  exit 1
fi

mfaLogin $1 $2

# Generate shell output
if [[ ! -z $awsSessionToken ]]; then
  expire=$(echo $awsSessionToken | jq -r '.Credentials.Expiration')

  echo export AWS_SESSION_TOKEN=$(echo $awsSessionToken | jq -r '.Credentials.SessionToken')
  echo export AWS_SECRET_ACCESS_KEY=$(echo $awsSessionToken | jq -r '.Credentials.SecretAccessKey')
  echo export AWS_ACCESS_KEY_ID=$(echo $awsSessionToken | jq -r '.Credentials.AccessKeyId')
  echo Keys valid until $expire >&2
else
  echo WARNING: No Session Token >&2
fi
