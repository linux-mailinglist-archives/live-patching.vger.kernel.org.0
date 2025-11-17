Return-Path: <live-patching+bounces-1863-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 621DFC6696C
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 00:50:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 0DEE7353493
	for <lists+live-patching@lfdr.de>; Mon, 17 Nov 2025 23:50:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C170B2D0C66;
	Mon, 17 Nov 2025 23:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UHre4xjq"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7642C3768
	for <live-patching@vger.kernel.org>; Mon, 17 Nov 2025 23:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763423423; cv=none; b=ixXvNiHH+BCr3DJDEwXMwZN4rdcWRkAr2Sq+wCvpTpB8pWln/VQjXegi+ogXHLZrfSuYFn4WlfEk45x+88OZnh/h5aPEEnjm5vAks4uvnqxP4MlF4v1R75K9leMnGpYd11ZWTRD6LPLioq2HLs5HyaZB3vdEznYgPZaANy/CdFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763423423; c=relaxed/simple;
	bh=L7ShX2R77QQlrirSYuHJKAuODl0vsxkf0fBM0UTfB4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Us2lnmdfnpCs1fTJdqwC8JPYUhsDpkmAT84hVdoKEFjAjOinjS6bUsS3TiRnChzt07tXu8hvADZVao+XxVAVHc5FtJLgMdlU0CEg8WPkcK3QvKdTtIIVcrvEv0oWlV4ArBbITOYAlZvQutoQ1dzgbAMOR+mFV4XEC84TezDmibQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UHre4xjq; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-640a503fbe8so8466261a12.1
        for <live-patching@vger.kernel.org>; Mon, 17 Nov 2025 15:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763423420; x=1764028220; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7ShX2R77QQlrirSYuHJKAuODl0vsxkf0fBM0UTfB4I=;
        b=UHre4xjqfYqz1GSJbY+Cht3ltsf1GQf6gGnMFDrXujXZ4mqpbN8iaAJhWqxEG1PY06
         Y2OozWi194iBKcbEdyGJ3LJbZP22cPjATlCNGLrRzhWeLPCAR2hPcDit/WyDQZFk3fgS
         aN/JjsVK2g4CEpndOHvXe2S5xBfIwXDXVxEoo/xMa4MCwT4a6M6lpfT6xNRzR6bOrRAs
         kjZv1mISTxCuTg14c/4vLIj8eZfIkADudk4IiRYtYNWe1tjyi1iGhgsRc2hwvj/a9BHq
         35cmcioCKG2YAxdW4x/hmHIoATl1sS3S91i0/Ns1p4XrxIhV4YOr1huHvew2V3Pjy3gg
         Q7xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763423420; x=1764028220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L7ShX2R77QQlrirSYuHJKAuODl0vsxkf0fBM0UTfB4I=;
        b=tFpHkqHVWxL/yO5X0N0Um79AqZzpkKMJe/fil0phr700kjr91MRaPtv/1L9zQtVZsN
         +YlIwDUmhXuCZLmq5/F+DvuiVX36lyc4iTwaSwq6RGiUYCVc0Kigga1x5/R/GV1f3Mq2
         no2Guo+l87p4F/WJ69N7NaQ6qLXK5SkTOl42itramn/frdNrLr05IJCUaUPJSJ88uDGl
         yqF3urT+NuASfDrwC/DczL9U/8TJphzjsTomB6RmMoN2lXhF77PESPpO/jsKidypJybm
         L2tPcFBFWSUzZ/BUfCMfZ9GIek1CfgqXxoKJb42/vhT0Px1MsrRsKXfKbRTpynIJyO31
         hPEA==
X-Forwarded-Encrypted: i=1; AJvYcCV8Eg5ObPvwvAAdI9WFRc91jGO4dJjUCHMczYISkp5Z60ITpcCWvhOlGwzEfTzq0/cilsRnyelSOVw3fSP4@vger.kernel.org
X-Gm-Message-State: AOJu0YwCTNo7TkiuVJW9a6It8kksAELZiZgYqlZ+JPgF4ejDH907LQ5r
	8yLSziBUqKSXsdmCseagg+GRBPusF5B/e5LR1b/EoYCQGp7Lt58FRNaYUQ8I+W4mLEd7o/RXpQK
	frzg8EY7CC9ZMJx/rfk3aUMCmmsAJllM=
X-Gm-Gg: ASbGnct7FnBHAYUWRP5Sm4RVMoxMo9717Y/8SBMyvwCQ6WjjVX04Pdekl47dqPj+RQt
	14NxSki28zh4stunnO6r62E0Eduqmre2HYhBlV5jT6u2L+pwHiWjI2IBGIlXo4MppqnbohbjD35
	2+8rebKtqogKax+Y8s8FgGZoatB3YC5I66c4ehrFF28xez6y0Eqjfn5o7Xi/1U6JoeUEv4n5KZR
	wBQEmyIWiNBXGIsIXN6Qbd4y6yojjgfxwEph46/aRLjoJ5ko0diEwHKycrpiCvRVYVKfb541eIJ
	CvyLpAV/jRaIFUxNgy2V2OPO9ds=
X-Google-Smtp-Source: AGHT+IFQBCppQ37igj5MnmLQkkId5sJwjkwb1o5CC811b5BkF5VmAHhj/INLgbzZeniV+AoWmxwTBSH4owwFCJAXr30=
X-Received: by 2002:a05:6402:520b:b0:640:edb3:90b5 with SMTP id
 4fb4d7f45d1cf-64350e004damr12716225a12.7.1763423420337; Mon, 17 Nov 2025
 15:50:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
 <CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
 <CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
 <CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com> <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
In-Reply-To: <nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
From: Puranjay Mohan <puranjay12@gmail.com>
Date: Tue, 18 Nov 2025 00:50:09 +0100
X-Gm-Features: AWmQ_bmaiM9OsS3x9uCVm7VnMLeJDAcfWpAUoA7xDr-W293gWhf_zCix61iNl2s
Message-ID: <CANk7y0hqnQR6X6rmVgA6O44WCf5QMiKVVJ31txWf-R9HtxhBBg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Song Liu <song@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jiri Kosina <jikos@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 12:06=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
>
> On Fri, Nov 14, 2025 at 10:50:16PM -0800, Dylan Hatch wrote:
> > On Mon, Sep 29, 2025 at 12:55=E2=80=AFPM Puranjay Mohan <puranjay12@gma=
il.com> wrote:
> > >
> > > I will try to debug this more but am just curious about BPF's
> > > interactions with sframe.
> > > The sframe data for bpf programs doesn't exist, so we would need to
> > > add that support
> > > and that wouldn't be trivial, given the BPF programs are JITed.
> > >
> > > Thanks,
> > > Puranjay
> >
> > From what I can tell, the ORC unwinder in x86 falls back to using
> > frame pointers in cases of generated code, like BPF. Would matching
> > this behavior in the sframe unwinder be a reasonable approach, at
> > least for the purposes of enabling reliable unwind for livepatch?
>
> The ORC unwinder marks the unwind "unreliable" if it has to fall back to
> frame pointers.
>
> But that's not a problem for livepatch because it only[*] unwinds
> blocked/sleeping tasks, which shouldn't have BPF on their stack anyway.
>

BPF programs can sleep, so wouldn't they show up in the stack?
Like if I am tracing a syscall with a bpf program attached using
fentry and the BPF program calls a bpf_arena_alloc_pages(), which can
sleep.

