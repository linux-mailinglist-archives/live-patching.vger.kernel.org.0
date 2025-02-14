Return-Path: <live-patching+bounces-1195-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64851A3597D
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 09:57:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10DC93AA9FE
	for <lists+live-patching@lfdr.de>; Fri, 14 Feb 2025 08:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9689522A80B;
	Fri, 14 Feb 2025 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PLb5V+BP"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E1E228CB3;
	Fri, 14 Feb 2025 08:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739523412; cv=none; b=RE0Fbl+oBu16sOOSfkSJCdzNCxqJkSYcPKKYN8+0R6QtmvkHdEm3joFIERcruxk7Li21+owTE99DnTzNEzfp1U/MbkKsn9MKgRJ96/wy6JCt2sN8fPubrJtaqGnIxD5Duq+VEqCf06oYDG+mvZU/OHn6qHjikEUK80w0FR6Sqe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739523412; c=relaxed/simple;
	bh=UuVe/NHpjUQBGvgHKZMk6upQjW6kuksHuEMlSdnEBFk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CssS+8Lw3pyERtunUUAP0ax9wR2o3ZIQvrgavOeur+40/xkOpg4zX6BsnBs+LuN1gxv82qZQOwL4vWliQ/bIR4TsJ2+uTNmB7JIvY37BFCO5P/P5yniM3UvBcHg+W6DjaiNrukzAb36zHylGi/gq4ocwpmPrMcu49iOt4V+ew4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PLb5V+BP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915AAC4CED1;
	Fri, 14 Feb 2025 08:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739523411;
	bh=UuVe/NHpjUQBGvgHKZMk6upQjW6kuksHuEMlSdnEBFk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=PLb5V+BPTWLjazx/H83Tlhn74+H9KFyzUk70ajeyViFUEAIYZCVfwNOYniwwZdbDB
	 PCmyg9F3+AxavgCGQOFIzm7QYLgH8p3WfaJCInKint0/6RkUlEeIth6x8yt+eVlNW4
	 +nzeWYTsuGLpDt3tjy/6AkA/thvnUMOvuKiEtWKU9URaXha9qC0h5fJfXJa/qAxDS7
	 ax8uJ00j6qqPPXBmuduhc5J/ZMMXznnWIPCb/tpJCZmKlafaMmFGTHf8EKLuMLDx+U
	 IARv8fIvL9Z/CPO8DK2rglf1FxrhTSmGU6vyPM/JNiex1/u4PTeRp3kmCfoJeTWrzk
	 E+vr+SRKF//0w==
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
In-Reply-To: <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
References: <20250127213310.2496133-1-wnliu@google.com>
 <CAPhsuW6S1JPn0Dp+bhJiSVs9iUv7v7HThBSE85iaDAvw=_2TUw@mail.gmail.com>
 <00fa304d-84bf-4fca-9b9a-f3b56cd97424@oracle.com>
 <CAPhsuW4ct6W_4B0LFEjLePH1pAeNm4h8ePuQ3HcSoknXhQWN0w@mail.gmail.com>
 <mb61p1pw21f0v.fsf@kernel.org>
 <CAPhsuW5VCmuPLd8wwzBp_Divnu=uaZQcrRLsjsEOJ9GmA0TR5A@mail.gmail.com>
 <mb61pseoiz1cq.fsf@kernel.org>
 <CAPhsuW7bo4efVYb8uPkQ1v9TE95_CQ6+G3q4kVyt-8g-3JD6Cw@mail.gmail.com>
 <mb61pr0411o57.fsf@kernel.org>
 <CAPhsuW7fBkZaKQzLvBqsrxTvpJsfJfUBfco4i=-=C_on+GdpKg@mail.gmail.com>
Date: Fri, 14 Feb 2025 08:56:45 +0000
Message-ID: <mb61p7c5sdhv6.fsf@kernel.org>
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

> On Thu, Feb 13, 2025 at 2:22=E2=80=AFPM Puranjay Mohan <puranjay@kernel.o=
rg> wrote:
>>
>> Song Liu <song@kernel.org> writes:
>>
>> > On Thu, Feb 13, 2025 at 12:38=E2=80=AFAM Puranjay Mohan <puranjay@kern=
el.org> wrote:
>> > [...]
>> >>
>> >> P.S. - The livepatch doesn't have copy_process() but only copy_signal=
(),
>> >> yours had copy_process() somehow.
>> >
>> > In my build, copy_signal is inlined to copy_process, unless I add noin=
line.
>> > If I do add noinline, the issue will not reproduce.
>> >
>> > I tried more combinations. The issue doesn't reproduce if I either
>> > 1) add noinline to copy_signal, so we are not patching the whole
>> >    copy_process function;
>> > or
>> > 2) Switch compiler from gcc 14.2.1 to gcc 11.5.0.
>> >
>> > So it appears something in gcc 14.2.1 is causing live patch to fail
>> > for copy_process().
>>
>> So, can you test your RFC set (without SFRAME) with gcc 14.2.1, so we
>> can be sure that it is not a sframe problem?
>>
>> And about having the .sframe section in the livepatch module, I realised
>> that this set doesn't include support for reading/using sframe data from
>> any module(livepatches included), so the patch I added for generating
>> .sframe in kpatch is irrelevant because it is a no-op with the current s=
etup.
>
> Puranjay,
>
> Could you please try the following?
>
> 1. Use gcc 11.4.1;
> 2. Add __always_inline to copy_signal();
> 3. Build kernel, and livepatch with the same test (we need to
>     add __always_inline to the .patch file).
> 4. Run gdb livepatch-xxx.ko
> 5. In gdb do disassemble copy_process.
>
> In my tests, both gcc-14.2.1 and gcc-11.5.0 generated a .ko file
> that looks weird in gdb-disassemble. Specifically, readels shows
> copy_process is about 5.5kB, but gdb-disassemble only shows
> 140 bytes or so for copy_process. clang doesn't seem to have
> this problem.
>
> I am really curious whether you have the same problem in your
> setup.

Hi Song,

I did this test and found the same issue as you (gdb assembly broken),
but I can see this issue even without the inlining. I think GDB tried to
load the debuginfo and that is somehow broken therefore it fails to
disassemblt properly.

But even with inlining, I couldn't see the warning about the refcount
with my setup.

Thanks,
Puranjay

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iIoEARYKADIWIQQ3wHGvVs/5bdl78BKwwPkjG3B2nQUCZ68FThQccHVyYW5qYXlA
a2VybmVsLm9yZwAKCRCwwPkjG3B2nWlnAQCVrkv46a1mIlCe/RDFg5P7r37Eq6h/
l5JEZS8o3EforwEAlJ1jBINFDr3sUWWrWm5r01MsNlkRrRlDUXf93um+dgU=
=ADzt
-----END PGP SIGNATURE-----
--=-=-=--

