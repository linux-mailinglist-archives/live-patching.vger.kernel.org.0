Return-Path: <live-patching+bounces-2270-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UD9tMJEYzGnHPgYAu9opvQ
	(envelope-from <live-patching+bounces-2270-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 20:55:13 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7129D370440
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 20:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3FE3C30445A1
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 18:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689383A6EEB;
	Tue, 31 Mar 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SSuGq70K"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6181E3A5442
	for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 18:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774983276; cv=none; b=oHyp3tgrAzNAKjbIEYfnrSzN8OQ+ePbcFbeT6MRIwE7VS/4Uui1e50Ih1tS/GdTZVHpiwZ9/gGvUeJ1fNopbq1fvb8S32e1WYxFUOj9FD14NoC4PuKaz+V68cWFoRklfxHwrCuC+6psY8+Uu1kvJWKApG4ZGLNeA+tPBH/HFZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774983276; c=relaxed/simple;
	bh=C8cbePc9rCnWFEp1scCgZP+x5olpD01MB2YflmlISyQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Fk4Py+iNPhNOg2/Z4lIAVNIDW04HvNlPNih0grGbUFh1hnMVSMRAtr/qVldJy4BxrM8rq5nymFGi+y26F0J+nMF8nfNdauhIkbS2N3KYvMKWXSvB95rISDXLGpZho1DEDb+9cCDDTY3N6+JK/DWDLE1ZvTDyGZ4yCjLipO0OlXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SSuGq70K; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4853e1ce427so74643305e9.3
        for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 11:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774983272; x=1775588072; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C8cbePc9rCnWFEp1scCgZP+x5olpD01MB2YflmlISyQ=;
        b=SSuGq70KZnGHFbWU3l2vAxU3MexztERT14KXnStsFXFEfosZXNhctQSiuD0Bg+EFhI
         zH7y21a/+Kq42pFrnt+0RDxjCpHVZscUuuG5dCBi6QP6a1fjs1WhzmsLCbS/0MQSmIYu
         OXiaHj8AwoBtTlNrkjyHXIXhyq18UO8nv2agNQRGcv4oxIVK9hpcDN/aYojnNVU61ChY
         4k+YLA+DrsAcRJ0GQpa6mjy3My53xMuZD6MgUjBSULa2vr2LG2U18ZIoOx8MazQD4vZL
         2vyN9p8jnPooea+YMBEpBzLmoeRCm7q7OAbgBFi3drz5aLK/9kIl0Cfc7L+HCVObpA4z
         mnAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774983272; x=1775588072;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C8cbePc9rCnWFEp1scCgZP+x5olpD01MB2YflmlISyQ=;
        b=CF27OD/eAjIXPSpag0E48bxck7mzFMz3ZWuYArDrap/OTJK3GjsNJK7Zk9EIc2wpgf
         a7R6mQcqMR5++NmY/NZtTv3Ho1N6e7xBPfv/VUQ+srWnu4yz+3FEKK/t7Re564iCb3Pd
         2YX5IxZSpb/61nLaFEWJaDfkb/6/a4PNYonn6xkUmJk+VA7i2MO6+7337loq5214Z0GL
         nUbZg1Tn/i86QBGhpLujOQYZYEcoJcz+ydK5Y+zlMVrrl9vlPz9Zuzdl53ZSU561A8Vr
         tx372E8MoHGhFFCpqIc21Z8leM0s2eZNzmJB6fQ283qw5UB2S2xxCsSfMZHs7NxBPcEi
         Pn7A==
X-Forwarded-Encrypted: i=1; AJvYcCVX2VIKrLnzjs8cZX3lix6TT3/TRYSS12a4JWzum8MhXA/h+qg6+u9p+yg5Apa5K7Mbvn7fqcw8vjxKQ4Lb@vger.kernel.org
X-Gm-Message-State: AOJu0YzJSuxbPjFep0oanh55fjrky5hGp1mjnOgmosaOhJkSUub1gVeI
	WKAeOYXFO/onwS8cQ4rjU/20lBoQ6cKVab9e1hKOBD6Dholo+6ruzXBPtLPSrG7jazQ=
X-Gm-Gg: ATEYQzzPx7y9bh3advZIg9w8ZrC3MDggzkn1qUl1RvlTTwjhf6WEEvcq98W7N/bbRQi
	n3LVjuVp92OfqPSYy+Eyp7mcG8yPQGash6+BNgbk8eBUzAuZ5rG3+jPA/e89dnrqevfy1UbfSGx
	a8DiOwNtrFsJDj3kHGnLdoXnJZlMk3E3lMuTkNnzsu/CEIS6kEjir169z8c85VH+VLnUBGzroEd
	iWGvE3orCN37vDRBvPINNuB8N2lNHLbzYXpFoGvZHRaCQGoLRLcV5+ZXrGDXTZrW7RKSTvfG1F9
	vFkA76h3p5KoJ2p5uVBvYrvS2gGJLJ5msJbUMpTUqLKF+gYS6SizFDvtE8Ljygky8QVFj++eICZ
	Lg0Oa9k1tVgzUmY+SOhui/XmkzvVBZkB7zhd6XPx2zaV8GM4aOng5yTw1VmrxtgNFW9dwAogelZ
	JXwt0nqvhKG26uf/VfjqUHla7oWvpY3nHSxlJWSsOXwOhpqNftm/nNjLnsSnzHv4niO80=
X-Received: by 2002:a05:600c:45d0:b0:488:80b6:872e with SMTP id 5b1f17b1804b1-4888355ec8emr8407915e9.2.1774983271652;
        Tue, 31 Mar 2026 11:54:31 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887e80148csm59006435e9.5.2026.03.31.11.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:54:31 -0700 (PDT)
Message-ID: <a23f00ad4a454cbb3379cdf512e8c61ce7499194.camel@suse.com>
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Shuah
 Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2026 15:54:25 -0300
In-Reply-To: <abhjYtyveer4niGM@redhat.com>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	 <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
	 <abhjYtyveer4niGM@redhat.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.0 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2270-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7129D370440
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, 2026-03-16 at 16:12 -0400, Joe Lawrence wrote:
> On Fri, Mar 13, 2026 at 05:58:32PM -0300, Marcos Paulo de Souza
> wrote:
> > Instead of checking if the architecture running the test was
> > powerpc,
> > check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.
> >=20
> > No functional changes.
> >=20
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > ---
> > =C2=A0tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > | 7 +++----
> > =C2=A01 file changed, 3 insertions(+), 4 deletions(-)
> >=20
> > diff --git
> > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > index dd802783ea849..c01a586866304 100644
> > ---
> > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > +++
> > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall.c
> > @@ -12,15 +12,14 @@
> > =C2=A0#include <linux/slab.h>
> > =C2=A0#include <linux/livepatch.h>
> > =C2=A0
> > -#if defined(__x86_64__)
> > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> > +#define FN_PREFIX
> > +#elif defined(__x86_64__)
> > =C2=A0#define FN_PREFIX __x64_
> > =C2=A0#elif defined(__s390x__)
> > =C2=A0#define FN_PREFIX __s390x_
> > =C2=A0#elif defined(__aarch64__)
> > =C2=A0#define FN_PREFIX __arm64_
> > -#else
> > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > -#define FN_PREFIX
>=20
> The patch does maintain the previous behavior, but I'm wondering if
> the
> original assertion about ARCH_HAS_SYSCALL_WRAPPER on Power was
> correct:
>=20
> =C2=A0 $ grep ARCH_HAS_SYSCALL_WRAPPER arch/powerpc/Kconfig
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 select ARCH_HAS_SY=
SCALL_WRAPPER=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if !SPU_BASE =
&&
> !COMPAT
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on PPC64 &=
& ARCH_HAS_SYSCALL_WRAPPER
>=20
> Perhaps I just forgot what that additional piece of information that
> explains the comment (highly probable these days), and if so, might
> be
> nice to add to this commit since I don't see it in 6a71770442b5
> ("selftests: livepatch: Test livepatching a heavily called syscall").

Looking again at the code and at the symbols for SLE for ppc64le, I can
say that, even with ARCH_HAS_SYSCALL_WRAPPER being set, the syscall
names are not changed for ppc64le. Looking at
arch/powerpc/kernel/systbl.c:

#ifdef CONFIG_ARCH_HAS_SYSCALL_WRAPPER
#define __SYSCALL(nr, entry) [nr] =3D entry,
#else
/*
 * Coerce syscall handlers with arbitrary parameters to common type
 * requires cast to void* to avoid -Wcast-function-type.
 */
#define __SYSCALL(nr, entry) [nr] =3D (void *) entry,
#endif


Differently from x86 and other already covered archs, the syscall name
remains the same on ppc. I will add a comment about it in the next
version, adding a case for ppc and an #else clause with an error, so
future architectures that support livepatching can add a patch here to
fix it for them.

>=20
> Thanks,
> --
> Joe

