Return-Path: <live-patching+bounces-1172-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9ADA338CA
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 08:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 202C616855F
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 07:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3802F209F25;
	Thu, 13 Feb 2025 07:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qx7v7ygt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E2420967F;
	Thu, 13 Feb 2025 07:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739431616; cv=none; b=WqptW6yq0U4B1A/Sw+OF2dZPJbM+auCwSblx1Kg4dzpxg1jEl7oqddSqF1/q96YzsHzv+HUV4lTj2GTDGtQOlveT7C/SgSmel0yKf91YJVoPukL8feoOWYYrYSyNY+Db0yPlMr/V2OA2MjOR9jCO3jx8MDkUFMuzENP37eqBuqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739431616; c=relaxed/simple;
	bh=6+6SjTJ5zbBWxWy5yIkCvwaE38nvcNBxMZbRUBc8RBA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CkYscMO/qbGLFeposKYTinTYY1ZY8hTbROULKSlHnFz73lXnn2gvZb5lxkT6Pwcam1Px6FnGlRZ2kSCsuTbyXBMGkQmhNyGwhM/iLnU5wo7GKp4CecfX03fXwCa7L/HEuNC5sf9W1LxYQfEYuwVDRblvcpvZ9OZd8FQj5Oirgcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qx7v7ygt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41550C4CED1;
	Thu, 13 Feb 2025 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739431615;
	bh=6+6SjTJ5zbBWxWy5yIkCvwaE38nvcNBxMZbRUBc8RBA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Qx7v7ygtKrp5rSxpDmVmUIHnSzBbeYd8tFVfNhPCmnc0laghy1eF9UUW+hkp4axZI
	 p+pkZQDVegMD0xm3EHURlq8KHEETkRi4ZQSmg2LGRy02CIxK4QTvgYjVG7OYGgSAUM
	 wDn64yV+nIYRD0E3wkknwkG9WffPbzMxPvrRKhV1hnQUu12ZoEt9fZoTM55TA3RHfi
	 k8oALO0XKrJs0K60AF3Kw677L0zcjITQDN1gQ/pNOPQV7teP9EGhnWtL1ubMEcQNaO
	 4VePFaZzNZrk2k0ywsV8S9ceu3hzuiDC3V/XFtRqQsNzzt7raO65NF3Fj8nlVh+SGw
	 ATXFLwjyl6NEg==
From: Puranjay Mohan <puranjay@kernel.org>
To: Song Liu <song@kernel.org>, Indu Bhagat <indu.bhagat@oracle.com>
Cc: Weinan Liu <wnliu@google.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 roman.gushchin@linux.dev, Will Deacon <will@kernel.org>, Ian Rogers
 <irogers@google.com>, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
Date: Thu, 13 Feb 2025 07:26:40 +0000
Message-ID: <mb61p1pw21f0v.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Song Liu <song@kernel.org> writes:

> On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@oracle.c=
om> wrote:
>>
>> On 2/12/25 3:32 PM, Song Liu wrote:
>> > I run some tests with this set and my RFC set [1]. Most of
>> > the test is done with kpatch-build. I tested both Puranjay's
>> > version [3] and my version [4].
>> >
>> > For gcc 14.2.1, I have seen the following issue with this
>> > test [2]. This happens with both upstream and 6.13.2.
>> > The livepatch loaded fine, but the system spilled out the
>> > following warning quickly.
>> >
>>
>> In presence of the issue
>> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect bad
>> data in SFrame section.  Which may be causing this symptom?
>>
>> To be clear, the issue affects loaded kernel modules.  I cannot tell for
>> certain - is there module loading involved in your test ?
>
> The KLP is a module, I guess that is also affected?
>
> During kpatch-build, we added some logic to drop the .sframe section.
> I guess this is wrong, as we need the .sframe section when we apply
> the next KLP. However, I don't think the issue is caused by missing
> .sframe section.

Hi, I did the same testing and did not get the Warning.

I am testing on the 6.12.11 kernel with GCC 11.4.1.

Just to verify, the patch we are testing is:

=2D-- >8 ---

diff -Nupr src.orig/kernel/fork.c src/kernel/fork.c
=2D-- src.orig/kernel/fork.c      2023-01-12 11:20:05.408700033 -0500
+++ src/kernel/fork.c   2023-01-12 11:21:19.186137466 -0500
@@ -1700,10 +1700,18 @@ static void posix_cpu_timers_init_group(
        posix_cputimers_group_init(pct, cpu_limit);
 }

+void kpatch_foo(void)
+{
+       if (!jiffies)
+               printk("kpatch copy signal\n");
+}
+
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
        struct signal_struct *sig;

+       kpatch_foo();
+
        if (clone_flags & CLONE_THREAD)
                return 0;
=2D-- 8< ---

P.S. - I have a downstream patch for create-diff-object to generate .sframe=
 sections for
livepatch module, will add it to the PR after some cleanups.

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ62esRQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nX0gAP9n3xA9wW2ZSrjqoyai0Z+h7Z03vgV0
y4f2blTpucfZtQEA7lPQavqv8zaPQ1pd3nsRfki49/OkrgrXQxoA1aAalAY=
=crNj
-----END PGP SIGNATURE-----
--=-=-=--

