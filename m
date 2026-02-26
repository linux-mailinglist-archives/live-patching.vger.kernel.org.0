Return-Path: <live-patching+bounces-2092-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGHUGVNboGm3igQAu9opvQ
	(envelope-from <live-patching+bounces-2092-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 15:40:19 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BB5861A7BCF
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 15:40:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 108D330BEE56
	for <lists+live-patching@lfdr.de>; Thu, 26 Feb 2026 14:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E923B9607;
	Thu, 26 Feb 2026 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EC3u1Hvr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F9A30FC2E
	for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772116480; cv=none; b=ssaezoPbnR32ldG1CJ/Iy+quxBsRCjsvIu76Ck8rErqxCY//7KnXvDuXEm5HxiDALXXUYqWmdwtvorz5AGsD7i829eieAVsKCe6j2w7uPCqeTZf+iKQAJBMb3kJbkw2gxOrUTBLQ58vAsIc1+krQ/2/BpTJrG1vFzbrN38ph48A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772116480; c=relaxed/simple;
	bh=gtA+H2X6ew7j0WLGn1Fvyy2afI0h2OIZDUA1JcW9sJo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rG6BEt5usVZx+BAjPkeceCxpuPLcqnY+cT9m8RRnrJKNJpYq3xt7e/xe2seGI/B2Xwuxzk4FcEGurobo572fjz0BKwAcH1ym1u3Sc5baRAHK+zob8hvUrM/+XsoFtMIh0RdyUK6WGYuAy50WVwMsWlVcQDzNCbO2zi1aQ8RMKGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EC3u1Hvr; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43990ea3fbcso646425f8f.0
        for <live-patching@vger.kernel.org>; Thu, 26 Feb 2026 06:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772116475; x=1772721275; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iB4u+09YhtcRl39ds1n5VvgzC6lBCx1avlF+QWd52Eo=;
        b=EC3u1HvrNOvh7/iEf4qwMT/+SLnOiKQLcuECOh/B6Fr/jki7zzaNFrK9aq/XG5u/YI
         zf++IY+le5jSBJgE1t3XUASOSmlePcWur41QjqlvWoN9LULci2RaebMYrAvJ8z84yxsb
         h6ell9yRfrZn5GVXmfAJry26tDvtyAQ0QrCMTrdWWhAMD3kRyy55HVaZR9v0hJT+Sh5R
         VdzYBcpK2j0Qlvzp73DAjKqmVmnURuBzlr6AtfXt9ZU8DT5nGJwf8MotPNwgCKf7/HWK
         WUw+riR/gFpyQopdYje/s/7aR2zbsPTLkF9GFGCNuj2MNUV8Uc/Euv4XV1bIHHGbwUXv
         meSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772116475; x=1772721275;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iB4u+09YhtcRl39ds1n5VvgzC6lBCx1avlF+QWd52Eo=;
        b=VQy6nDF6reYCF9AhspODTW+mxJXOVDu0q26v6qKW3JNSU6iFlQ9QxemaOTRFu6THVv
         lhNUEMNPgHU0/FlL3yYmJSpj+KXvwh5U8Y/r49pfSialJyZsnD4UkYwsEhYrADbZExzC
         VV6WikhepYbQh9Y+OxONiYSXp6AP8+B1JbTb7DEm5D4a+2fL6LkZqt4v3Z9LlqA0hVtF
         aRz7x+0mWN7w7ECmcY9PerVCD8xxnh2ci9iAvVAmnpNeo5f1I9UF409p0tW48XsRvfJu
         O3ygJMhh9vuAvYuqyAwpRINWyvwAp6kpjVKaVDwfK2fEF2L0TPEQgEsgGVFEgfxtKcBx
         BQ4g==
X-Forwarded-Encrypted: i=1; AJvYcCW1nlovmG97zQKPNSRFE27PKiq+YrKtQZPnBD60EruTEqpl8njlh12Hf8Y3F7qKppIqE1W3AqL+08wd1GIB@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk1MUYZ1dkWxU1pSa8ZYsC5KjKcj1L6ACuxtV109SVXTkPnEA2
	WFdcHr2MtAMIAVesqYLhJLIWsXf5CJF0sJmuKHk9yha9JAf1GMyfSIzf/sXI5bYmvis=
X-Gm-Gg: ATEYQzzfc6fm609A8nJPYEJMBRiN7XOIWMPCWZBWbAU9zBwMFUQwTAzc2giIMbTwgdD
	XTYcuRq//PeaY3s4hZ+ti4qvPxdvzR5csHElKcCLW25LhMdfvZNZ3wNC4YeEk5D0mXVQk6yGgrK
	V7XhRJAwpMT6I5mIVHJ41G9iiSuWY+KGUKXTF+2fJjjK46pQIUU8uxrhTQsdSQcWxn0LSGHXF/R
	f3IbU5H5NUU0URhEF8F031bn6LItOGX4n1B0AkUFwTThO+mpBGDMLJBh59xVIU/zsbfQl1YaBES
	xNAlgKE4IjrSVH0bxFrrVAFefKZoLMG0kyt1qkhN3B5U8hPbM6L6pCI88Duhyq8M75CQg9xwcsJ
	cp8LO6syEwt3JAJA25JhQHmYFQx0OINzc+LklCO4uqW6Pdhgal1xyXyG6cSwhapAeMNVMYMALH4
	qwdDZBAfYzsT4RQlsNTSUAOjzi0ZDcMkLEAffKW+CLoKi+hjNL03CVRJkieiWTiD/Czm+nPPIl
X-Received: by 2002:a05:6000:2f84:b0:437:6c0c:346c with SMTP id ffacd0b85a97d-439972045b9mr5398962f8f.28.1772116474640;
        Thu, 26 Feb 2026 06:34:34 -0800 (PST)
Received: from ?IPv6:2804:5078:822:3100:58f2:fc97:371f:2? ([2804:5078:822:3100:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43995056115sm7530873f8f.14.2026.02.26.06.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:34:34 -0800 (PST)
Message-ID: <3a4a2d27c241bda76a0b5cf812f7921088d5cbd8.camel@suse.com>
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>,  Jiri Kosina <jikos@kernel.org>, Petr Mladek
 <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>, 
	live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Thu, 26 Feb 2026 11:34:28 -0300
In-Reply-To: <alpine.LSU.2.21.2602261337170.5739@pobox.suse.cz>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
	  <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
	  <aZx1ViTc7NJws-rf@redhat.com>
	 <5ca16692b304185df695e517434b16e59cb15a42.camel@suse.com>
	 <alpine.LSU.2.21.2602261337170.5739@pobox.suse.cz>
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
	TAGGED_FROM(0.00)[bounces-2092-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ftrace.sh:url,suse.com:mid,suse.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BB5861A7BCF
X-Rspamd-Action: no action

On Thu, 2026-02-26 at 13:40 +0100, Miroslav Benes wrote:
> Hi,
>=20
> On Mon, 23 Feb 2026, Marcos Paulo de Souza wrote:
>=20
> > On Mon, 2026-02-23 at 10:42 -0500, Joe Lawrence wrote:
> > > On Fri, Feb 20, 2026 at 11:12:34AM -0300, Marcos Paulo de Souza
> > > wrote:
> > > > When running current selftests on older distributions like
> > > > SLE12-
> > > > SP5 that
> > > > contains an older bash trips over heredoc. Convert it to plain
> > > > echo
> > > > calls, which ends up with the same result.
> > > >=20
> > >=20
> > > Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> >=20
> > Thanks for the review Joe!
> >=20
> > >=20
> > > Just curious, what's the bash/heredoc issue?=C2=A0 All I could find
> > > via
> > > google search was perhaps something to do with the temporary file
> > > implementation under the hood.
> >=20
> > # ./test-ftrace.sh=20
> > cat: -: No such file or directory
> > TEST: livepatch interaction with ftrace_enabled sysctl ... ^CQEMU:
> > Terminated
>=20
> I cannot reproduce it locally on SLE12-SP5. The patched test-
> ftrace.sh=20
> runs smoothly without 2/2.
>=20
> linux:~/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh=20
> TEST: livepatch interaction with ftrace_enabled sysctl ... ok
> TEST: trace livepatched function and check that the live patch
> remains in effect ... ok
> TEST: livepatch a traced function and check that the live patch
> remains in effect ... ok
>=20
> GNU bash, version 4.3.48(1)-release (x86_64-suse-linux-gnu)
>=20
> Does "set -x" in the script give you anything interesting?

Nope:

boot_livepatch:/mnt/tools/testing/selftests/livepatch # ./test-trace.sh
+ cat    =20
cat: -: No such file or directory           =20
+ set_ftrace_enabled 1                                    =20
+ local can_fail=3D0


Same version here:
GNU bash, version 4.3.48(1)-release (x86_64-suse-linux-gnu)

I'm using virtme-ng, so I'm not sure if this is related. At the same
time it works on SLE15-SP4, using the same virtme-ng, but with a
different bash:
GNU bash, version 4.4.23(1)-release (x86_64-suse-linux-gnu)

So I was blaming bash for this issue...

>=20
> Miroslav

