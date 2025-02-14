Return-Path: <live-patching+bounces-1192-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E88A3584B
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 08:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E96033AAB14
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 07:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98BE421CA13;
	Fri, 14 Feb 2025 07:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LRYL1LKI"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4D021518D;
	Fri, 14 Feb 2025 07:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739519883; cv=none; b=jvETBGcYxqOPugpbCMJv7iTye/1ajUqswXa07W8CpebY226pNuKYqxLN0ioaKUDJFInOFbcjLXgvjWufUvT2R9dCMHElJGKOyQa7/4AarQ/JgvhojrqPLzNHpuiN3YoXoNhNZ7Y5S/KkT5yEvoIZNv9d3oqqH658ynlgtSXDioY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739519883; c=relaxed/simple;
	bh=d3Ys6i0pcHC4QJ9ezhAppBA19L0NecIOEu/6ko+SHUg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=qjMXfZ/LNlh/jRG3U7kfauHt6v4CIiEUsoDdJkG+BPAGSKJTf7fS8gCrLRCIdiymWFQKPNOoo+Huf5ot3fdYFW7lJPLUDv6MFp2Og6nRpzaIJml1ZQDb+3mJPQajWoII5mAJf/a0KyEyNHVnNZjUTljCCuY3ZjypjbFE5gnhLIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LRYL1LKI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80737C4CED1;
	Fri, 14 Feb 2025 07:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739519882;
	bh=d3Ys6i0pcHC4QJ9ezhAppBA19L0NecIOEu/6ko+SHUg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LRYL1LKIIgSuex9GsqyripdUVEEnfE32XtoUYWVHfqL/q8yrz2okT5sl4Fq6+SlOt
	 3Vie9hJEh7jAeH1O1gxyo9IrUaTNXNWoLBgIzCqYe4n8UHtxcPwj3Rw6cYEE6GMqO6
	 hkpGk7rcLe1H6ZUG6eqAYLu+BHPAMTGfSny25GHDUGF3PYVhlZzZ9UyFtazDffgjby
	 rLR8l2PzMr+Et4sRI+RV9+E+xEkhRsKjwPZZJfixBSUphKWAFy1wwUHNPZZhN5Okgw
	 rzRS0iIEjRFvTaVF+/Hnvr7a69uZiv+dMbzsWohH+5v8aKA4bLeeBC7HfFQ5hoXUfl
	 1Ypmidf6UO8jg==
From: Puranjay Mohan <puranjay@kernel.org>
To: Indu Bhagat <indu.bhagat@oracle.com>, Song Liu <song@kernel.org>, Josh
 Poimboeuf <jpoimboe@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, roman.gushchin@linux.dev, Will Deacon
 <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
 <3069bb9c-6245-4754-a187-ac8253103d32@oracle.com>
Date: Fri, 14 Feb 2025 07:57:47 +0000
Message-ID: <mb61pa5apc610.fsf@kernel.org>
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

Indu Bhagat <indu.bhagat@oracle.com> writes:

> On 2/12/25 11:25 PM, Song Liu wrote:
>> On Wed, Feb 12, 2025 at 6:45=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
>>>
>>> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
>>>>>> [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_static]
>>>>>
>>>>> Does that copy_process+0xfdc/0xfd58 resolve to this line in
>>>>> copy_process()?
>>>>>
>>>>>                          refcount_inc(&current->signal->sigcnt);
>>>>>
>>>>> Maybe the klp rela reference to 'current' is bogus, or resolving to t=
he
>>>>> wrong address somehow?
>>>>
>>>> It resolves the following line.
>>>>
>>>> p->signal->tty =3D tty_kref_get(current->signal->tty);
>>>>
>>>> I am not quite sure how 'current' should be resolved.
>>>
>>> Hm, on arm64 it looks like the value of 'current' is stored in the
>>> SP_EL0 register.  So I guess that shouldn't need any relocations.
>>>
>>>> The size of copy_process (0xfd58) is wrong. It is only about
>>>> 5.5kB in size. Also, the copy_process function in the .ko file
>>>> looks very broken. I will try a few more things.
>>=20
>> When I try each step of kpatch-build, the copy_process function
>> looks reasonable (according to gdb-disassemble) in fork.o and
>> output.o. However, copy_process looks weird in livepatch-special-static.=
o,
>> which is generated by ld:
>>=20
>> ld -EL  -maarch64linux -z norelro -z noexecstack
>> --no-warn-rwx-segments -T ././kpatch.lds  -r -o
>> livepatch-special-static.o ./patch-hook.o ./output.o
>>=20
>> I have attached these files to the email. I am not sure whether
>> the email server will let them through.
>>=20
>> Indu, does this look like an issue with ld?
>>=20
>
> Sorry for the delay.
>
> Looks like there has been progress since and issue may be elsewhere, but:
>
> FWIW, I looked at the .sframe and .rela.sframe sections here, the data=20
> does look OK.  I noted that there is no .sframe for copy_process () in=20
> output.o... I will take a look into it.

Hi Indu,

I saw another issue in my kernel build with sframes enabled (-Wa,--gsframe):

ld: warning: orphan section `.init.sframe' from `arch/arm64/kernel/pi/lib-f=
dt.pi.o' being placed in section `.init.sframe'
[... Many more similar warnings (.init.sframe) ...]

So, this orphan sections is generated in the build process.

I am using GNU ld version 2.41-50 and gcc (GCC) 11.4.1

Is this section needed for sframes to work? or can we discard
.init.sframe section with a patch like following to the linker script:

=2D- 8< --

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinu=
x.lds.h
index 6a437bd08..8e704c0a6 100644
=2D-- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -1044,9 +1044,16 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROP=
ELLER_CLANG)
 # define SANITIZER_DISCARDS
 #endif

+#if defined(CONFIG_SFRAME_UNWIND_TABLE)
+#define DISCARD_INIT_SFRAME *(.init.sframe)
+#else
+#define DISCARD_INIT_SFRAME
+#endif
+
 #define COMMON_DISCARDS                                                   =
     \
        SANITIZER_DISCARDS                                              \
        PATCHABLE_DISCARDS                                              \
+       DISCARD_INIT_SFRAME                                             \
        *(.discard)                                                     \
        *(.discard.*)                                                   \
        *(.export_symbol)                                               \

=2D- >8 --

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ673fRQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2ne/eAQC3MvMRgb8+tzHOKgUa02OQ8qhh8Qda
ugo9amOhQSojUwEA/O95Eq3WPvdzumKfUGDoCSjxPWA9E0HeESbhvVIuIAw=
=Qfo9
-----END PGP SIGNATURE-----
--=-=-=--

