Return-Path: <live-patching+bounces-2238-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wOXQHzwFvGmurAIAu9opvQ
	(envelope-from <live-patching+bounces-2238-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 15:16:28 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EDBAF2CC8CE
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 15:16:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCD6F324781B
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2026 14:11:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82D83033E1;
	Thu, 19 Mar 2026 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="S5m57HWr"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94923033D6
	for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773929490; cv=none; b=BjAJc9Hhhc8cC3Ng4ccGQIZ8vm0jS4wbrksUmUHrEWE/YsUSkimFl2cj1sq4I/XX9+mhO5j02vXTtlCNJ65C4UgTJ1Qx0BMCAUAM46ptLnDTgwFDDv0N4bPgyKTXcvZM83bETzvSDVVwsDvQjhIl/0jkxkpkBhvhGjcENLnvITg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773929490; c=relaxed/simple;
	bh=ZoKqfLZmL/m8aDQmzpCMQIqxQutaiEBwAABS+Lwg80w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IrNI/+4D7FXQxZZl9/mSUNQhoED0v32ghZMtvW1ysqG3hPbMpP8WuMMx/RH78kB5+I5XRJgJLoMVRotKVlg5+XE55j/aFg7FoKOJtxq0j8ukCFxTl+Q5RYcjBR2B+Sl3GhGhfNQ1GsQum2wdBVBQyfHbGuPoR3ZVqMah4f4y5gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=S5m57HWr; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso3432095e9.1
        for <live-patching@vger.kernel.org>; Thu, 19 Mar 2026 07:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773929484; x=1774534284; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZoKqfLZmL/m8aDQmzpCMQIqxQutaiEBwAABS+Lwg80w=;
        b=S5m57HWr87aghFW/RbHgO8/EdA9Lzep/dbn8C1EUNPLwIBRMG1eCLTK0nAUdT+Ip0O
         szn8za9rWVDady2QlwylZk9CDol9jSUHJeWAuYDQDB8/45qCk+XsyOeSc+Y7SK5pvDcH
         +cv4iNnUZ1Pd1G5fcYzz74fsBfKuZ58X3sGQUu2BP/83MhcjC2Rq3SVExf+/B61jlt+x
         SGyEXX7orHWY5wRIoa7VbMkYng7Rh/l2F+Hte7qu/h56SYKdF9klcSXoaPHGHeRn3CV/
         BZ+SP4ahzZul7MliJeIa8HwngjD3zhQdwiSuT20Hz4atrP9s1Ix/ffVsxXHzqihCr9nc
         O+IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773929484; x=1774534284;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoKqfLZmL/m8aDQmzpCMQIqxQutaiEBwAABS+Lwg80w=;
        b=RuvS7y/8BPkmnw714qa9033/oZcTMDz8R1YqMo1uvkhJ281tYmedL8UJ/nRVLBKWpU
         ifdf3qPz0OmybxzR4y4hXBs4yJ9mQTGLcXlLyRoaj+nA+EeSM+EmpWqUV20K/NPGbMsu
         a+c8sg+1GlrnO6iy9jrmp6fON0KPPnnor2K4lW7axnE9Dh2T+SwClHjjOEAIh8PplQZS
         oeUIlK5js8A2Wu5FC/CEEOuf4qD1oAOt4aqEZRvkdsLlWhz7Kov5W0X9YgyO0a2ngddm
         Bdu9M7DnbphVpkMetvN+HkA/d9s2ebrJ9WJtjsMi9l7RclQJEoQNcNqhS3iq2kz8ulee
         5LuQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0KRgsua78hTCoPHFv71STlmY4AFFFlXsfcuQkyDWBC9OvwnQFxVXvsXti/hcndufMElXFrq4nNPvk08wJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yzm7SbOVdRqeUoY84grNFH1oVJvFyEK9QWTk4oY1yYAS0tTnloa
	vBg8bwUPZxoyihXgR4wI6hbj+nQBsZBNe0UmAvJz5z4fwF6s02Y0h9WAsDFQ3Ud6how=
X-Gm-Gg: ATEYQzwyyBDGlUfhkT+80X0Cm7fbCc9TnbnUsMFTSrSBZ6EViNkDCRxYiI5+r3/dN+d
	P4GH4SFbdpdOUSSe+Aw9H1YXlhOulWYZYXlu42NJpPNd/rSvKIPX/y+FtPOiALmZgBqGfYDiLrF
	nBJSu6Wr061NQXlXlPrbVt7o2tg5UTUgElVbThCNL53bR5wvV1LErp1gDxIayeoKBor6KrWMsXB
	udv84rFg5HMeqSukbnui5J9uBZkMqg83GkKJEfKasVrbQQH01MsbNztJ4/k+2VkOH/TA28y3thq
	vozz3BOnay4V8nGuqYSSakPSO6pjTNGhzOgtC2PRyRoxXOXtgurSbbt1pHL+IpZ1uRz6RHiuUeh
	ibqtNdX0nU0JUF0OmqNsWuQrjNWsclEqvnjX2OerkHOL3Zczz2UFv3PuFATygwfMXGsGaHFamT3
	q2BAZFD531XI/FSHIR1DGhfTHrL04ulSuaVWis84urvKzhJlnvAxRZht/9WTVmJg==
X-Received: by 2002:a05:600c:3516:b0:485:3b34:2f51 with SMTP id 5b1f17b1804b1-486f44220f2mr121294065e9.4.1773929483990;
        Thu, 19 Mar 2026 07:11:23 -0700 (PDT)
Received: from ?IPv6:2804:5078:834:1300:58f2:fc97:371f:3? ([2804:5078:834:1300:58f2:fc97:371f:3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f4bc320dsm77929105e9.4.2026.03.19.07.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 07:11:23 -0700 (PDT)
Message-ID: <0d85d8d7533a7a78d1f8fcc1fff8ffc73b1cf225.camel@suse.com>
Subject: Re: [PATCH 1/8] selftests: livepatch: test-syscall: Check for
 ARCH_HAS_SYSCALL_WRAPPER
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Petr Mladek <pmladek@suse.com>, Shuah Khan <shuah@kernel.org>,
 live-patching@vger.kernel.org, 	linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Date: Thu, 19 Mar 2026 11:11:19 -0300
In-Reply-To: <alpine.LSU.2.21.2603191349440.22987@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	 <20260313-lp-tests-old-fixes-v1-1-71ac6dfb3253@suse.com>
	 <abhjYtyveer4niGM@redhat.com>
	 <alpine.LSU.2.21.2603191349440.22987@pobox.suse.cz>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2238-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: EDBAF2CC8CE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 2026-03-19 at 13:54 +0100, Miroslav Benes wrote:
> On Mon, 16 Mar 2026, Joe Lawrence wrote:
>=20
> > On Fri, Mar 13, 2026 at 05:58:32PM -0300, Marcos Paulo de Souza
> > wrote:
> > > Instead of checking if the architecture running the test was
> > > powerpc,
> > > check if CONF_ARCH_HAS_SYSCALL_WRAPPER is defined or not.
>=20
> There is a typo...=20
> s/CONF_ARCH_HAS_SYSCALL_WRAPPER/CONFIG_ARCH_HAS_SYSCALL_WRAPPER/

Thanks, I'll fix it in my next version.

>=20
> > >=20
> > > No functional changes.
> > >=20
> > > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > > ---
> > > =C2=A0tools/testing/selftests/livepatch/test_modules/test_klp_syscall=
.
> > > c | 7 +++----
> > > =C2=A01 file changed, 3 insertions(+), 4 deletions(-)
> > >=20
> > > diff --git
> > > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall
> > > .c
> > > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall
> > > .c
> > > index dd802783ea849..c01a586866304 100644
> > > ---
> > > a/tools/testing/selftests/livepatch/test_modules/test_klp_syscall
> > > .c
> > > +++
> > > b/tools/testing/selftests/livepatch/test_modules/test_klp_syscall
> > > .c
> > > @@ -12,15 +12,14 @@
> > > =C2=A0#include <linux/slab.h>
> > > =C2=A0#include <linux/livepatch.h>
> > > =C2=A0
> > > -#if defined(__x86_64__)
> > > +#if !defined(CONFIG_ARCH_HAS_SYSCALL_WRAPPER)
> > > +#define FN_PREFIX
> > > +#elif defined(__x86_64__)
> > > =C2=A0#define FN_PREFIX __x64_
> > > =C2=A0#elif defined(__s390x__)
> > > =C2=A0#define FN_PREFIX __s390x_
> > > =C2=A0#elif defined(__aarch64__)
> > > =C2=A0#define FN_PREFIX __arm64_
> > > -#else
> > > -/* powerpc does not select ARCH_HAS_SYSCALL_WRAPPER */
> > > -#define FN_PREFIX
> >=20
> > The patch does maintain the previous behavior, but I'm wondering if
> > the
> > original assertion about ARCH_HAS_SYSCALL_WRAPPER on Power was
> > correct:
> >=20
> > =C2=A0 $ grep ARCH_HAS_SYSCALL_WRAPPER arch/powerpc/Kconfig
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 select ARCH_HAS_=
SYSCALL_WRAPPER=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if !SPU_BAS=
E &&
> > !COMPAT
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 depends on PPC64=
 && ARCH_HAS_SYSCALL_WRAPPER
> >=20
> > Perhaps I just forgot what that additional piece of information
> > that
> > explains the comment (highly probable these days), and if so, might
> > be
> > nice to add to this commit since I don't see it in 6a71770442b5
> > ("selftests: livepatch: Test livepatching a heavily called
> > syscall").
>=20
> I would take a bit further. We would rely on=20
> CONFIG_ARCH_HAS_SYSCALL_WRAPPER being set/unset per listed
> architectures=20
> "correctly" for us. If it changes somehow (though I cannot imagine
> reasons=20
> for that but let's say we add new architecture. LoongArch also
> supports=20
> live patching.), the above might evaluate to something broken.
>=20

I agree. Given that nobody even complained about it, I would say that
people testing on ppc64le has this defined correctly. Whenever new
archs start supporting livepatching, we can always revisit.

> So I would perhaps prefer to stay with the logic that defines
> FN_PREFIX=20
> per architecture and has also #else branch for the rest. And more
> comments=20
> never hurt.

Agreed.

>=20
> Btw, see also=20
> https://sashiko.dev/#/patchset/20260313-lp-tests-old-fixes-v1-0-71ac6dfb3=
253%40suse.com
> =C2=A0
> for the Sashiko AI review. It also commented on this patch. Marcos, I
> guess that you will look there and I will just omit what Sashiko
> found in=20
> my review if I spot the same thing.

I already checked there. Maybe adding more context to the patch and
code will avoid further confusion about it. Let me add it in the v2.
Thanks for the reviews Miroslav and Joe!

>=20
> Miroslav

