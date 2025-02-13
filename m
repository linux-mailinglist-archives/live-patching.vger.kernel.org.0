Return-Path: <live-patching+bounces-1175-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6002A33946
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 08:53:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C611888B7A
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 07:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317FA20AF8A;
	Thu, 13 Feb 2025 07:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1iOU9zY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027B320AF6C;
	Thu, 13 Feb 2025 07:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739433215; cv=none; b=VlpDEQxBLEGPCCEKyZ+YiQn59AjBV2iQqT4ZDhZiuTb1lk725qwqlhiaMM1lPjCARK272P052pbOC0jY/dBf9MTHViKDa/MHLq35KlfzA6cEltOg42AXfRv5xnJhcTicHv2QtAMQp8HZBXoXN2xtnfRaU7N0uTON2oLKm9zccbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739433215; c=relaxed/simple;
	bh=SlOp3q3mUFP/fD5O04MBbXfcN5XIWxmKvPTMhBlEFx0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=LjjGvOvNKPjuE2IajorbQW/Bl++aVQkNmIiOEGCdYjT1mp7wHej8Y0VznMSGLTjjQKfYH9zV7pUbjhpYs/v8Z3AzlWdLNvXFIx51ItHDzvK6JeVkObeip1RT0V0pFXnMqA78qBsO026R0Y/PvUpxiN2s9GYwASPBKKJjGvHUtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1iOU9zY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C112C4CED1;
	Thu, 13 Feb 2025 07:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739433214;
	bh=SlOp3q3mUFP/fD5O04MBbXfcN5XIWxmKvPTMhBlEFx0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=u1iOU9zYjjs59zBWlMZW/Ux+8qEGJUc1W4jtjvHX5PTc370uXfjQ9pmuHchWYCQ6t
	 XQLG07Z06HWQu59qNfSutUR9oy72B8R6lVAEGraiOUdqEBJRK1XWc7ksIUhfFnRiQN
	 5dfxHWyRf2xNlPM+b7cktk+wAn5qYTUIKHIk2vlgk0pmhrIeAI/KdisgUumeokdETx
	 5AAaZT/ab/wF5SyKnbyfKkpEbrzTKXbuAF/IyYIVXxqnR7ITWPeXxRcEPAHaxpal2L
	 jQUHk6/083eL8HJG2bMvFqK9LIfR2nnRR5QgQO14Do9jrl0nVLoRH+EKXHB7Bmg1gk
	 4Ci0gSbKPduDw==
From: Puranjay Mohan <puranjay@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Indu Bhagat <indu.bhagat@oracle.com>, Weinan Liu <wnliu@google.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Mark Rutland
 <mark.rutland@arm.com>, roman.gushchin@linux.dev, Will Deacon
 <will@kernel.org>, Ian Rogers <irogers@google.com>,
 linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, joe.lawrence@redhat.com,
 linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
In-Reply-To: <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
 <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
Date: Thu, 13 Feb 2025 07:53:27 +0000
Message-ID: <mb61pv7tez3ew.fsf@kernel.org>
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

> On Wed, Feb 12, 2025 at 11:26=E2=80=AFPM Puranjay Mohan <puranjay@kernel.=
org> wrote:
>>
>> Song Liu <song@kernel.org> writes:
>>
>> > On Wed, Feb 12, 2025 at 4:10=E2=80=AFPM Indu Bhagat <indu.bhagat@oracl=
e.com> wrote:
>> >>
>> >> On 2/12/25 3:32 PM, Song Liu wrote:
>> >> > I run some tests with this set and my RFC set [1]. Most of
>> >> > the test is done with kpatch-build. I tested both Puranjay's
>> >> > version [3] and my version [4].
>> >> >
>> >> > For gcc 14.2.1, I have seen the following issue with this
>> >> > test [2]. This happens with both upstream and 6.13.2.
>> >> > The livepatch loaded fine, but the system spilled out the
>> >> > following warning quickly.
>> >> >
>> >>
>> >> In presence of the issue
>> >> https://sourceware.org/bugzilla/show_bug.cgi?id=3D32666, I'd expect b=
ad
>> >> data in SFrame section.  Which may be causing this symptom?
>> >>
>> >> To be clear, the issue affects loaded kernel modules.  I cannot tell =
for
>> >> certain - is there module loading involved in your test ?
>> >
>> > The KLP is a module, I guess that is also affected?
>> >
>> > During kpatch-build, we added some logic to drop the .sframe section.
>> > I guess this is wrong, as we need the .sframe section when we apply
>> > the next KLP. However, I don't think the issue is caused by missing
>> > .sframe section.
>>
>> Hi, I did the same testing and did not get the Warning.
>>
>> I am testing on the 6.12.11 kernel with GCC 11.4.1.
>
> Could you please also try kernel 6.13.2?
>
>> Just to verify, the patch we are testing is:
>
> Yes, this is the test patch.
>>
>> --- >8 ---
> [...]
>> --- 8< ---
>>
>> P.S. - I have a downstream patch for create-diff-object to generate .sfr=
ame sections for
>> livepatch module, will add it to the PR after some cleanups.
>
> Yeah, I think the .sframe section is still needed.
>

Hi Song,

Can you try with this:
https://github.com/puranjaymohan/kpatch/tree/arm64_wip

This has the .sframe logic patch, but it looks as if I wrote that code
in a 30 minute leetcode interview. I need to refactor it before I send
it for review with the main PR.

Can you test with this branch with your setup?

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ62k+RQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nZisAP9MPQWg3UbuY0yZpUIb4byCtNEENv9t
0uusw4iksm0tqAD/Z9W9tKL7DknJZNY4HVPTLUDdLbjgBRX557V7MwQn1ww=
=wnd5
-----END PGP SIGNATURE-----
--=-=-=--

