Return-Path: <live-patching+bounces-2067-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AhoAFV/nGm6IQQAu9opvQ
	(envelope-from <live-patching+bounces-2067-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 17:24:53 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 579C4179AEA
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 17:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B95BD306BD13
	for <lists+live-patching@lfdr.de>; Mon, 23 Feb 2026 16:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E476A30E829;
	Mon, 23 Feb 2026 16:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AdjPnyqv"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749FE267B90
	for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771863712; cv=none; b=a83crUO8VcfXlISGglB3OECp3gp0m9HBofu+HQ/9o/S7o4wa+wptOpai+Yaf3/TsWKoLojPfLQUxatLlIL3Z0FYdIRc7cgJN63/QhIbnihSv9PZikKD2sWyGsSn0kE37sAmqlUjJemYeM3e70tltCmmZd2jIkQ26mUuBJ8+JVB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771863712; c=relaxed/simple;
	bh=cZdjdaZOcsXK6GsQf/mEIq7Qdmf7HWSKukscx0FcygU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eb1OwrpdGfgMmG6ReoDHirHxjtCc7anqSJuwzRmW8FdE82K3rRDYqz0unfaMievzSeT/pfdS2hKY51lk8VOf1jQV5o6PSmKh0vj8lT3oSiWeIFb2N/1vXWUnNxfa8fZHJX8pMKxTo7yjjxJVMoh12+6PJytKmGd0Bymtq8WGKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AdjPnyqv; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-436e8758b91so3085549f8f.0
        for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 08:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771863710; x=1772468510; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=E12DLppc9zEwEUJULEgbOPg9LHuCkYx1Y+7qBt2BKRc=;
        b=AdjPnyqv0QCL36Ta+bRjeVvowMl5s9TcXCppQhECzdRxr9lx5R4RSUI1lebk/lc1rj
         sVUFf0sQegOvTqrirJZYRqIEVDvPIineIT+3OC7mdxrO7I6EDdKb1qgQt0nJl1NobAo1
         xfjkKqIcV64S4FRlWdnTaBa7248Wi53ssF0xGgtXY+IwtQNbarcQFTxzRPfWJFkUq2Rn
         U0kFzy7eVLd612fGUbiyXXSrrjxupHSECEQYA5z+vFs/COu2AO/lwh6ZVs0nXVgT7ysV
         VedDkWY80HnnGF7N4kvGosnL9t3q4ebnKV39lPmH/DCRIcom2SGwHQGHaRYl/nzvVLfN
         Igrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771863710; x=1772468510;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E12DLppc9zEwEUJULEgbOPg9LHuCkYx1Y+7qBt2BKRc=;
        b=RggmB+rm+daoqZbTOiPCCwdWU7dWm74SgwLvr17i8z8LvgngT7Gm3+3FGrYYvdFke3
         tDg3pAWX3lM9UDcTsY4w9ql07Kvk6O46L6B5GSsfpUH5O6neayUrh4e3rzy7qhk3Uyu2
         I9gkPgiK+2VgWBwzjtuVqVe64OGSoXVMDbGdJ3DK8zs7SXIx4AW9zZ3bwIylPOhGts8j
         NE/KdhKfpdwGYWmyKRYFL9a5pY3XckO4SRw6zCQ49UVFsPNzvzVU8vWtzsOLEMfugk4S
         0cz5minDAASAOuR8qZPsr8EPMUYHiflg5EUuIkKbNCLik63OWb+WdYbkRTty4ateMz9y
         EYrw==
X-Forwarded-Encrypted: i=1; AJvYcCU1bVWPolHQLtgM1V8ojeBOPVrR+Onr0HjohS1mxk0Hqxxn5uMrisOkJWiLTCVz/6ZIuOp1Io6T+nRnhR2A@vger.kernel.org
X-Gm-Message-State: AOJu0YwyTcVGSp6unHOic48H+ZYwLCprrggy7aMOXAiy6E9B1oNGYmEM
	pcJxpC0I2rsynnx7pM7heYkzfODeXSaTKYkBTA0zIt0g5gVnInm7hf0YtUYkR+B28uQ=
X-Gm-Gg: ATEYQzzKcXun4FTuKF7iRHXyVlgt/T7qyV6EWg2XTPX0l3K+966WcGtIZmi+xt4Atp1
	jDw+fIdCWGCnLPcFSidydTspRrhnlEgJi7R5ggwZoatyzHDt+t71nUZiD/3Rn8Jn6nt1hR4UKDi
	tkrebojyvs6D51tbmMQcxIuipiyFZ+5coM+0agcODrH8Ay7Zfp6p/JL4lhm9EMSxU1d2zGcAF2V
	myGMwYtJVzQHBuT9UqDsbrs8hUP9rO43rEcuxyVz7HRM7mdM0p9uR9sMdx9L89zYxhQgjs/FjAe
	eQ/zu9ESXVIp89MZBqR17FWmJJKvcKPsWXzdE0+6zk4VXwPDnX7CJ7L95RJxvHO8yYT5+8/EeOC
	BANGaiFwe/bGKsTOw7p4k22CbrciR28EitfWB7c2jH0KanQKHVKkPTYIGzCV1hnkSyYi/ptXxI/
	vIAxHdLqJgbuCFgDbrI2IvyN7TtiwSaOU6do61ScrY0jc9Q14+97qZrsQyZMDcDw==
X-Received: by 2002:a05:6000:230b:b0:437:71cc:a246 with SMTP id ffacd0b85a97d-4396f153cd2mr18596170f8f.10.1771863709655;
        Mon, 23 Feb 2026 08:21:49 -0800 (PST)
Received: from ?IPv6:2804:5078:822:3100:58f2:fc97:371f:2? ([2804:5078:822:3100:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970c00e8bsm16973432f8f.15.2026.02.23.08.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:21:49 -0800 (PST)
Message-ID: <5ca16692b304185df695e517434b16e59cb15a42.camel@suse.com>
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Shuah
 Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Mon, 23 Feb 2026 13:21:43 -0300
In-Reply-To: <aZx1ViTc7NJws-rf@redhat.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
	 <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
	 <aZx1ViTc7NJws-rf@redhat.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2067-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 579C4179AEA
X-Rspamd-Action: no action

On Mon, 2026-02-23 at 10:42 -0500, Joe Lawrence wrote:
> On Fri, Feb 20, 2026 at 11:12:34AM -0300, Marcos Paulo de Souza
> wrote:
> > When running current selftests on older distributions like SLE12-
> > SP5 that
> > contains an older bash trips over heredoc. Convert it to plain echo
> > calls, which ends up with the same result.
> >=20
>=20
> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks for the review Joe!

>=20
> Just curious, what's the bash/heredoc issue?=C2=A0 All I could find via
> google search was perhaps something to do with the temporary file
> implementation under the hood.

# ./test-ftrace.sh=20
cat: -: No such file or directory
TEST: livepatch interaction with ftrace_enabled sysctl ... ^CQEMU:
Terminated

Somehow it doesn't understand the heredoc, but maybe I'm wrong...
either way, the change has the same outcome, so I believe that it
wasn't bad if we could change the cat for two echoes :)

Either way, if Petr or you think that this should be left as it is,
it's fine by me as well, I was just testing the change with an older
rootfs/kernels.

>=20
> --
> Joe
>=20
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > ---
> > =C2=A0tools/testing/selftests/livepatch/functions.sh | 6 ++----
> > =C2=A01 file changed, 2 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/tools/testing/selftests/livepatch/functions.sh
> > b/tools/testing/selftests/livepatch/functions.sh
> > index 8ec0cb64ad94..45ed04c6296e 100644
> > --- a/tools/testing/selftests/livepatch/functions.sh
> > +++ b/tools/testing/selftests/livepatch/functions.sh
> > @@ -96,10 +96,8 @@ function pop_config() {
> > =C2=A0}
> > =C2=A0
> > =C2=A0function set_dynamic_debug() {
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 cat <<-EOF > "$SYSFS_DEBUG_=
DIR/dynamic_debug/control"
> > -		file kernel/livepatch/* +p
> > -		func klp_try_switch_task -p
> > -		EOF
> > +	echo "file kernel/livepatch/* +p" >
> > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> > +	echo "func klp_try_switch_task -p" >
> > "$SYSFS_DEBUG_DIR/dynamic_debug/control"
> > =C2=A0}
> > =C2=A0
> > =C2=A0function set_ftrace_enabled() {
> >=20
> > --=20
> > 2.52.0
> >=20

