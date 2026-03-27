Return-Path: <live-patching+bounces-2264-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIJgNImFxmlALQUAu9opvQ
	(envelope-from <live-patching+bounces-2264-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:26:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4F33452B3
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 14:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CF36030B8A13
	for <lists+live-patching@lfdr.de>; Fri, 27 Mar 2026 13:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3015C3ED122;
	Fri, 27 Mar 2026 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="d0n8Adjt"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16733EC2F5
	for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 13:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774617399; cv=none; b=Kt5BXUSuNZw2hKkZCkxELOzRyA13ZeGzYBAV0BU8O5Nfy4cNlX9Hytm2pfF/RKTmiyemeQstGzoa4ZxN4gxPoVpO9LQgBsiIdRSd0sOXf/exI2qRh6abvHsqsc90B7OWRuFdcDCmlyeCn2AhH65BC/wXuFqvtEpKEHz4DS1tikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774617399; c=relaxed/simple;
	bh=fOSwO/08J9ekwjCj2b/zkOD/4BJnhPM8z+0Ya75IJ40=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JYPueqBZ03k9gxcZP4Wei1kDOFxC1ZHWl4qUtDnF6auBhCCxLg9PDPE0H/DpS4S+7jb9pv3FR5SLSfXJNFf21OlFO95d4SumOoi+Y6TysrMH0BpJj/5R0euKbYMbh/0gcO+UvtG3bim8GJhKNh3zzhoMzqvv9ryBZTxYyazjaMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=d0n8Adjt; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-486b9675d36so18672085e9.0
        for <live-patching@vger.kernel.org>; Fri, 27 Mar 2026 06:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774617396; x=1775222196; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fOSwO/08J9ekwjCj2b/zkOD/4BJnhPM8z+0Ya75IJ40=;
        b=d0n8Adjt5FDHJKxjwUQ9vfamlseAmza9SkHVfyDVcSYJfKYV9Z7F+BXBLQw4BytVwQ
         vHwykwFzZHdTT4WDehiZbGDkjZ7OstuOsY1/kpDdficzeyFQfXiuUrSeEGvFIlMPv+Py
         X6anu1zv9VGhOyex0LKpkmom7qYzOqC1OHU5fyWsB+6YYdqOqRfoPGeNg9KghYwcI1GC
         rR+As8d/LH4t5E3N5T1U44o7OzSa3LkRXNjxFHHK7E6BL8dPDt3wanIgexmei47NW1q1
         v7x+7NUiLT4y50g1bEt33iLXJD+ii3qNjZADp7zY9jXKz+1LJZZbOrecE5t1l02lg5jh
         Sp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774617396; x=1775222196;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fOSwO/08J9ekwjCj2b/zkOD/4BJnhPM8z+0Ya75IJ40=;
        b=rw0OQBPV/awWXWUl9GhX5/uNtu6ZbG3i9NANoh6J5jPT8lC5HCfrntC9IWSy/LXaLN
         SxEUdYJyLin9YAGwJh5mJXfzSlnFwHzxAZ10fp4zWEybFAEjILTROid1q2WvzHPG2EHG
         f7RB0fAbkPtHPL9AbJ2xsBYgz3wAkcXu1fzWtGl+XVtSDACq1DOs7sXDhD/tCOeExt77
         saGa+Eaa/wEwvlxM+MkDjnzAxvixsSTvKkz/x2YJBSUOWlwYzbN0y4BQVxMLA2Sbg7kW
         2BQ0x+948JEecsu2eM3jfsKjptwFqEjyq6TTsGjiSbmEYUyyG+bYYmLeXpU3df0vSGQ3
         EJIw==
X-Forwarded-Encrypted: i=1; AJvYcCWbRr1Y+fgeLu/kQN4pBfnCrmPwEq8/jBMbGMWSt5G2hIc2Zhaxef3Edzy7teeiKN7EPzD7DB/r2Ns5wt1x@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6zGdeSzV8IXfef4K4omAbZrfPyzMLm4VocqFSljlsqaaqEAqN
	iOvC3+Q+5HWGvfSD3pDksPND10J7NzFRdjXkqomzeaJb+bHU9gQDz7o9kcNQcI57Tq8=
X-Gm-Gg: ATEYQzy2oALyoJ9rUCJayEz9eO5ydpX+Q3DjSRhBSNBVH2zQg8nYy0h3enbncNK35Z8
	HDF38M8zGS6x7fnV5Yy1Zv77t0RX94/WAfat3H1nIEFOxkEHwvZlfEdgAqQJdP/ircS35imftzC
	XlgsPoZO/XWjECeorrUlcjGZRYdqeWhtPQxfZAJ/lRR3skLqEAsv/v8ljUq68v9Qvcqkxd5B4WP
	fU1rojdmvcCM82rGHxGNHp5WagLGQxtk9jigt7y/nz6uoHpwT5hFNQYq90e9ESNRyBcwCKmf1bs
	i1SLWCZwUt0XzEnhCB9YWfh/FQLSAEI6C0cw/SEe6Af8q1wT4YfQPs5Kgzvcmfy49mzZEnPsbYH
	HvTRuS9yLjvjV6fdtiHgMFzHjDFFdoJMkqbefWBiGrn8PcAO+lh9hNgk5D38IepV0l3/zebMQ8+
	YMZ5p7l7zxNahma/nExn8L6Rftje9weu+0mLd2aPrfCVDvArUo/rnuWo5Wlv8lNva/J6y3Kw==
X-Received: by 2002:a5d:5887:0:b0:437:6d8c:c08a with SMTP id ffacd0b85a97d-43b9ea66f5bmr3852764f8f.45.1774617395872;
        Fri, 27 Mar 2026 06:16:35 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:c8ca:fb24:208a:b63f? ([2804:1bc4:224:7800:c8ca:fb24:208a:b63f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919e7111sm14930162f8f.37.2026.03.27.06.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 06:16:35 -0700 (PDT)
Message-ID: <533b0452cdedcf065c73898e4d574fe339bfb347.camel@suse.com>
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Shuah
 Khan <shuah@kernel.org>, 	live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org
Date: Fri, 27 Mar 2026 10:16:29 -0300
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
User-Agent: Evolution 3.58.3 (by Flathub.org) 
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2264-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: BC4F33452B3
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

Sorry for the late reply...

Well, so far the test always run fine for us, so I never looked why ppc
didn't have ARCH_HAS_SYSCALL_WRAPPER TBH... I can add some information
about it, sure. =20

>=20
> Thanks,
> --
> Joe

