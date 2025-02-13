Return-Path: <live-patching+bounces-1174-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C8A9A33923
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 08:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A7C7166B1E
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 07:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 030D220A5CE;
	Thu, 13 Feb 2025 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W47A3+26"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB6513CF9C;
	Thu, 13 Feb 2025 07:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739432787; cv=none; b=ZCq+bCO2OJ73BVpWvDipHsPtrkLinwUnl5Kk+We2UA+AycgYLnYs9Zz7YXoNFBM9yyvVrwsGVcJUPSBiQuIEc8VpYhyo15IQbpvNRZjJT4t1+FLVPhbozToM5jL72A/BQqx88WVvvrgiIO1PKH1BCubB6eW+XvXWIoIfIF7fYJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739432787; c=relaxed/simple;
	bh=JGGbLDBxCkqR8K/NNEPGyugpXiMGBbR2y/dGhIlBpSQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bNDYsmO5MjRU9Z5ZifDSY/gG1dMKGI43dHkm/9mo0DoTdfClGb2M6LnzHJ0J/KFWwv/Ip9SF3ckZeBsm5R65bg7u+CAlWIWkxnPMoTgy28KimO1hjMxqcuefidvWt7Q2FYI6IsaMSHWDlmHu3Fyv4lCrXMZwdl/22YkvMI5gyIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W47A3+26; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2887C4CED1;
	Thu, 13 Feb 2025 07:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739432787;
	bh=JGGbLDBxCkqR8K/NNEPGyugpXiMGBbR2y/dGhIlBpSQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=W47A3+26jJO+aOSyBxEQffv5xzRZH6zJsXCpbhKr2RKv6VurJxmYSBHg19HA1sCru
	 L6hKZePewkqAsotyeSTjuiRTJv6VFoSYZ/TZxiOILMWzhabQte/4eZZTnDornch7Bb
	 9RsoJv52jtJA2WtujUA+URSzzyouzSGpubHGnUdWiwy4E21JCyuEXgjEYYOoZQvGZD
	 usTfaOk2wWSpuejQ4JYDOW10+H3TEfUbI5YIfiZmJhNCZhijECx0A8ew1x2L+ngu/L
	 vTEeAc5Wo+fWFSL2BzUZfauY5ZuTvM0VFooa9FAnjQDG+d1ZcV6QflUAP5tl4tP1oR
	 BDmrH8yEkVFAA==
From: Puranjay Mohan <puranjay@kernel.org>
To: Song Liu <song@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Weinan Liu <wnliu@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra
 <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>,
 roman.gushchin@linux.dev, Will Deacon <will@kernel.org>, Ian Rogers
 <irogers@google.com>, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <20250212234946.yuskayyu4gx3ul7m@jpoimboe>
 <CAPhsuW5TeMXi_Mn8+jR9Qoa=rAWasMo7M3Hs=im6NT6=+CrxqA@mail.gmail.com>
 <20250213024507.mvjkalvyqsxihp54@jpoimboe>
 <CAPhsuW4iDuTBfZowJRhxLFyK=g=s+-pK2Eq4+SNj9uL99eNkmw@mail.gmail.com>
Date: Thu, 13 Feb 2025 07:46:21 +0000
Message-ID: <mb61py0yaz3qq.fsf@kernel.org>
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

> On Wed, Feb 12, 2025 at 6:45=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.o=
rg> wrote:
>>
>> On Wed, Feb 12, 2025 at 06:36:04PM -0800, Song Liu wrote:
>> > > > [   81.261748]  copy_process+0xfdc/0xfd58 [livepatch_special_stati=
c]
>> > >
>> > > Does that copy_process+0xfdc/0xfd58 resolve to this line in
>> > > copy_process()?
>> > >
>> > >                         refcount_inc(&current->signal->sigcnt);
>> > >
>> > > Maybe the klp rela reference to 'current' is bogus, or resolving to =
the
>> > > wrong address somehow?
>> >
>> > It resolves the following line.
>> >
>> > p->signal->tty =3D tty_kref_get(current->signal->tty);
>> >
>> > I am not quite sure how 'current' should be resolved.
>>
>> Hm, on arm64 it looks like the value of 'current' is stored in the
>> SP_EL0 register.  So I guess that shouldn't need any relocations.
>>
>> > The size of copy_process (0xfd58) is wrong. It is only about
>> > 5.5kB in size. Also, the copy_process function in the .ko file
>> > looks very broken. I will try a few more things.
>
> When I try each step of kpatch-build, the copy_process function
> looks reasonable (according to gdb-disassemble) in fork.o and
> output.o. However, copy_process looks weird in livepatch-special-static.o,
> which is generated by ld:
>
> ld -EL  -maarch64linux -z norelro -z noexecstack
> --no-warn-rwx-segments -T ././kpatch.lds  -r -o
> livepatch-special-static.o ./patch-hook.o ./output.o
>
> I have attached these files to the email. I am not sure whether
> the email server will let them through.

I think, I am missing something here,

I did :

objdump -Dr livepatch-special-static.o | less

and

objdump -Dr output.o | less

and the disassembly of copy_process() looks exactly same.

> Indu, does this look like an issue with ld?
>
> Thanks,
> Song

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ62jThQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nSJWAP9HM6jijr9CHiI0TTsvKU41K4RJKnSA
ACLOomAKVD3b2gEA+ZOrgnaTgwLNMQtfl4tcQIKU78wweS2kXsAjr2V4/wA=
=HUa3
-----END PGP SIGNATURE-----
--=-=-=--

