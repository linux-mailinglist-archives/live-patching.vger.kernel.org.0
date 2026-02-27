Return-Path: <live-patching+bounces-2096-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6GiXJn+roWm1vQQAu9opvQ
	(envelope-from <live-patching+bounces-2096-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 15:34:39 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D9011B90B4
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 15:34:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A4F0D3008D17
	for <lists+live-patching@lfdr.de>; Fri, 27 Feb 2026 14:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC762C158D;
	Fri, 27 Feb 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gJk1XxQ/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90C32C159E
	for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 14:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772202526; cv=none; b=YOe/8C4eZP83WFdzInTz8aIU8MnaDQClSQj6oHGAcwKF+tkHZEQWvaf68hYdYIhU8XvoaFKJDaCa2uGml6Wi2TDpi2C5zwSl6TpR4XJOY/eV9sdQa/sW/XAPH1YJ/h3xcH9b+o1FYS2gMlMg9yARh7mpXcxH2X6auYtE1f64NSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772202526; c=relaxed/simple;
	bh=i6cBFMHUsx0EJf2CjWn4sCmkc35R9btH0euWmqlbYsk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FRD3DNKcTLa7H/rJ9FGToWTDTRX/Ha5/PxApBsvSXVWYId3IphnB5JDMd5DPUAsmKiBQcdxWMLiZ/Us+Mn7ml9tYAx9BWH1ECw5dhcuOWP6lleFU5+iJt9PG0RCH77wiSrPXoGGPAfZcWR81/FdJmzHBuIme5AXNnNcCG7g3Yw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gJk1XxQ/; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso17267685e9.0
        for <live-patching@vger.kernel.org>; Fri, 27 Feb 2026 06:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772202522; x=1772807322; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i6cBFMHUsx0EJf2CjWn4sCmkc35R9btH0euWmqlbYsk=;
        b=gJk1XxQ/D3JcPOla8s1C33DQ/wDdlxRIWCZoj/ews5RSQwIIk6UlLtGFiGUFLSeouH
         XdJUve0YN591X3z/dH49gM+Qh9KzN5ftOpXJZRZskelZ3XQhLIlHMEwXUkXELbjPDlq7
         jU+MdpSlfo3+OuasNsYzHSsrNMx4gXh8qiX078Ard4OL/bWqhARyvO+hD2V+rxtA44yt
         eStZBw58j2y0FdrzM7wOEYCt65E+EZftUGPQ66La6t2/430Dr6skxdAw282EIq/OkQf8
         YpafWujcuLm6oWQ7EmXx7AooynmRme4+iiEGJvr25r/i4kYS04CmwP34GUHbp8ik21O1
         nF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772202522; x=1772807322;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6cBFMHUsx0EJf2CjWn4sCmkc35R9btH0euWmqlbYsk=;
        b=ljn7pnvNFcvs8Fl+2/zzk1K3DTDEtUBTTtGFpJh2qu1OCBumS6G2EPBi7i+MahmFM9
         TC/xTOLDnO5x/wF7dD8PPGkc/dphHitkSZNRJeszlAo/NACpwitXlhmqxICFoRpyuI08
         85uJo4gjhSdPgq7393sOwTpt2rb8mHRIn5CtlgRzdYh1mO8ftICoZnXSXuN8bY3l9COO
         cEW0WebBx8eVjkLOteFOWelqOeMK89kLCFXFbtsrZp+rxmDhoM7WvB0QZNibw4g98Rbn
         gRtBHOCdxKkE9wCsXSSb+lckwZwjxpkswdvNPjl2lIuwr4xVkkjAxaRdTm4FP9QZPv0U
         CeGg==
X-Forwarded-Encrypted: i=1; AJvYcCUq0Mg6bd3JnqFIJfQYGzOUBA19AaYhWwaeLEuSkxzSyqg9IWIsQaZvb1fITQAgk4R4CFSFrpbfbuZfp6z1@vger.kernel.org
X-Gm-Message-State: AOJu0YzvvaKwUk5eHeeFZ+cMfgQv/chn+TPmBsQz2sDn0EgDmloiHYg0
	3i7tG0Zff+kHu4xYGXEWKhfGMnXnSxGoGm/T0EalgetP6MU90H8YXp5baCdG1lzlaOg=
X-Gm-Gg: ATEYQzx39BT2wMCvQ+Xrt8dryG3Dk3oqiJP4XMHDg8SqrOW6TpaK4cVoT33sxA3Lkhg
	5qONnwCaZzLV7r/KpSqXiSVDNxWwa6ErIq2qJXoI4u5tbPXTtANPkXpwJJd1KBU2GdNU2NW1SUh
	YYJ/TpVe7EdaxrNqJw5r+ltd2fXw3tzFO7wxo/r+hVyhRX+xw/fJbDKJ1+rYcPfiEuqjV9uDb9N
	jLOmlwIALy4u8Jsu+fQdjL7Jmhxp2oHfJslnj8VvI8KZTXeiwOLlBmdh73nafjFlMXRUs+a/nac
	N/QPLUNGxBWrEl2dKlY0ubV5YBv8Z3GUlJE4PwveTtfA5a2JsQdWFflBErUP/hy9ZvIbBjVtvWD
	FAUtHq5KWn6UE7UHr/PEUnXyRCzW61PRqiiYkO6o3JQhAa88FtL5XKS8GM9CJzArL+xN0wczq2k
	DS2AQwSDXOlPV66uyquyDAUquhEnLeLuDGCfEralRq8wGRLrXuytLJXl9DhMQSJ3BWlXjXBHOW
X-Received: by 2002:a05:600c:470a:b0:477:abea:9028 with SMTP id 5b1f17b1804b1-483c9ba68eemr42134715e9.6.1772202522131;
        Fri, 27 Feb 2026 06:28:42 -0800 (PST)
Received: from ?IPv6:2804:5078:81a:8e00:58f2:fc97:371f:3? ([2804:5078:81a:8e00:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56a9215ac92sm6872333e0c.14.2026.02.27.06.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 06:28:41 -0800 (PST)
Message-ID: <42ab207746352197bc11fc9c2eafcb8663cd1362.camel@suse.com>
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Petr Mladek
 <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Fri, 27 Feb 2026 11:28:37 -0300
In-Reply-To: <3a4a2d27c241bda76a0b5cf812f7921088d5cbd8.camel@suse.com>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
		  <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
		  <aZx1ViTc7NJws-rf@redhat.com>
		 <5ca16692b304185df695e517434b16e59cb15a42.camel@suse.com>
		 <alpine.LSU.2.21.2602261337170.5739@pobox.suse.cz>
	 <3a4a2d27c241bda76a0b5cf812f7921088d5cbd8.camel@suse.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2096-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[trace.sh:url,ftrace.sh:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 0D9011B90B4
X-Rspamd-Action: no action

On Thu, 2026-02-26 at 11:34 -0300, Marcos Paulo de Souza wrote:
> On Thu, 2026-02-26 at 13:40 +0100, Miroslav Benes wrote:
> > Hi,
> >=20
> > On Mon, 23 Feb 2026, Marcos Paulo de Souza wrote:
> >=20
> > > On Mon, 2026-02-23 at 10:42 -0500, Joe Lawrence wrote:
> > > > On Fri, Feb 20, 2026 at 11:12:34AM -0300, Marcos Paulo de Souza
> > > > wrote:
> > > > > When running current selftests on older distributions like
> > > > > SLE12-
> > > > > SP5 that
> > > > > contains an older bash trips over heredoc. Convert it to
> > > > > plain
> > > > > echo
> > > > > calls, which ends up with the same result.
> > > > >=20
> > > >=20
> > > > Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> > >=20
> > > Thanks for the review Joe!
> > >=20
> > > >=20
> > > > Just curious, what's the bash/heredoc issue?=C2=A0 All I could find
> > > > via
> > > > google search was perhaps something to do with the temporary
> > > > file
> > > > implementation under the hood.
> > >=20
> > > # ./test-ftrace.sh=20
> > > cat: -: No such file or directory
> > > TEST: livepatch interaction with ftrace_enabled sysctl ...
> > > ^CQEMU:
> > > Terminated
> >=20
> > I cannot reproduce it locally on SLE12-SP5. The patched test-
> > ftrace.sh=20
> > runs smoothly without 2/2.
> >=20
> > linux:~/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh=20
> > TEST: livepatch interaction with ftrace_enabled sysctl ... ok
> > TEST: trace livepatched function and check that the live patch
> > remains in effect ... ok
> > TEST: livepatch a traced function and check that the live patch
> > remains in effect ... ok
> >=20
> > GNU bash, version 4.3.48(1)-release (x86_64-suse-linux-gnu)
> >=20
> > Does "set -x" in the script give you anything interesting?
>=20
> Nope:
>=20
> boot_livepatch:/mnt/tools/testing/selftests/livepatch # ./test-
> trace.sh
> + cat=C2=A0=C2=A0=C2=A0=C2=A0=20
> cat: -: No such file or directory=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=20
> + set_ftrace_enabled 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=20
> + local can_fail=3D0
>=20
>=20
> Same version here:
> GNU bash, version 4.3.48(1)-release (x86_64-suse-linux-gnu)
>=20
> I'm using virtme-ng, so I'm not sure if this is related. At the same
> time it works on SLE15-SP4, using the same virtme-ng, but with a
> different bash:
> GNU bash, version 4.4.23(1)-release (x86_64-suse-linux-gnu)
>=20
> So I was blaming bash for this issue...

This patch can be skipped. For the record, I discovered that it only
happens when vng is called using --rw, making it to fail on older bash
since it doesn't create overlays for /tmp. If the overlay is added the
issue is gone.

So, this patch can be skipped. Thanks Miroslav for testing!

>=20
> >=20
> > Miroslav

