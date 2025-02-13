Return-Path: <live-patching+bounces-1186-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DACAEA35122
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 23:22:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B6E216D4D1
	for <lists+live-patching@lfdr.de>; Thu, 13 Feb 2025 22:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B9C26E14D;
	Thu, 13 Feb 2025 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AR3Dgd/T"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C665926E149;
	Thu, 13 Feb 2025 22:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739485331; cv=none; b=sIU1I/ISPzMBexd1jH//Q1VQrbICyQqWgCkEcW3yw2XyJMAlUJqhKcFtcRYcpf2cdIyty3Qf9FO9s5KHx/r4RXTQX8t/JdM2zPKYGZfkHIyIFRPl2O9W8RGzpOsRLMOEEWtc39js7pWanoRGbGibi33BOE3OEoPYwW3SIgbX1GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739485331; c=relaxed/simple;
	bh=1CK4Id1eVmFWpaG9sBn/f5OOpSSTObssqjz+m90Pw/Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RDSEU9z+uszAQ1NcFiZkPskLv401Gcgo8vo91O0o0klYRVCFcIew2Disl8N/jpEUU2CXDQumfC7/KQuhpP3z1SSucgF488r6AsH9nP/9IbqlvGXuZLaWX2nRASIL1yF4tCqujUyzb4QygYZqWUjIg4i90oih5ETiQI//SDVhpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AR3Dgd/T; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D6FC4CED1;
	Thu, 13 Feb 2025 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739485331;
	bh=1CK4Id1eVmFWpaG9sBn/f5OOpSSTObssqjz+m90Pw/Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=AR3Dgd/Thu5XTheN4qPYo+SAQXGxp5T4IpvAt/Kc4zZjty/EuSjXV+G969chRz5Wr
	 ePiwdGtrSNhp5UkXpqAN500/3ouTTulmfDuFn5GqTS0HT8iBZCCNU/4wyBGJZSszWN
	 CZDwr2kjIatY8CSN9qJ6seR2CmCARMKYiC7dj+Mo+gc2PMYZ19xXHhms8rL+YrJVKU
	 FKwF87uYsTGue7jqMY+3OGpYXy9QE9mfOZ4yMf2oi+1gaP02ZzcbZz+RmfLHDgicwT
	 LGiq+ek9d0UUigac1MkJ9fyl83N0i95T7wMxlwmTL0Zw+knhL2q+uYMqAGrXKvsm7r
	 BcpZCuX1Avv1w==
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
In-Reply-To: <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
 <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org>
 <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
Date: Thu, 13 Feb 2025 22:21:56 +0000
Message-ID: <mb61pr0411o57.fsf@kernel.org>
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

> On Thu, Feb 13, 2025 at 12:38=E2=80=AFAM Puranjay Mohan <puranjay@kernel.=
org> wrote:
> [...]
>>
>> P.S. - The livepatch doesn't have copy_process() but only copy_signal(),
>> yours had copy_process() somehow.
>
> In my build, copy_signal is inlined to copy_process, unless I add noinlin=
e.
> If I do add noinline, the issue will not reproduce.
>
> I tried more combinations. The issue doesn't reproduce if I either
> 1) add noinline to copy_signal, so we are not patching the whole
>    copy_process function;
> or
> 2) Switch compiler from gcc 14.2.1 to gcc 11.5.0.
>
> So it appears something in gcc 14.2.1 is causing live patch to fail
> for copy_process().

So, can you test your RFC set (without SFRAME) with gcc 14.2.1, so we
can be sure that it is not a sframe problem?

And about having the .sframe section in the livepatch module, I realised
that this set doesn't include support for reading/using sframe data from
any module(livepatches included), so the patch I added for generating
.sframe in kpatch is irrelevant because it is a no-op with the current setu=
p.

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ65whhQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nXWqAP9pVx9qJCjxq8KKmY3TYqtRawZ5avzZ
L9AnG4+ojKoTFgEAjMbsGnNIDh7r5dpbZs7ds6oAq67Xuxw73oRLsXNrrgY=
=wSlN
-----END PGP SIGNATURE-----
--=-=-=--

