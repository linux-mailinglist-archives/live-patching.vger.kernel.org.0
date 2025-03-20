Return-Path: <live-patching+bounces-1309-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A531A69E32
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 03:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C4E18A61E1
	for <lists+live-patching@lfdr.de>; Thu, 20 Mar 2025 02:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837991E98FC;
	Thu, 20 Mar 2025 02:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzUjHydg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ED379F2;
	Thu, 20 Mar 2025 02:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742437241; cv=none; b=POmZ4cf6lGoKKbN2OMGtdl0jh8c7QLWx7o+pUzH5jTddPGQ8uQ5xsyTtgdsv3rbWi4234uD8uqfFfD7LrwAfQuzKj0xOnxKW3zVuEGS02xB7qxgdfkqVgNK/Vjc57ENMP+nswrH0FjOVLIybXdqDhJWm7DgS1tr393G/Ysdlr7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742437241; c=relaxed/simple;
	bh=B5xAUVdyEBI5NL4o0X34PUirmR2TMscmcGA1yOiYol8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Whn3GvzAhYzcZzvlt9dKe7pQVyoPElSclh6+ILINTG53CuUF6iSy1ug7XahN5nJhIXcj27ZsmYr6H1SoCa7TfkVHpEDhb3yx9HyCYznp3ysRZ6we25t5Gwl2ZMuA9eWecN/ucNpSiyrOB4DKZVZfH1Qr8qvcQxeVeCZjJjCb5qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzUjHydg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5139C4CEEA;
	Thu, 20 Mar 2025 02:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742437239;
	bh=B5xAUVdyEBI5NL4o0X34PUirmR2TMscmcGA1yOiYol8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VzUjHydgqjH1fNZlmVcYri/7HKzDk2PNpb3Y2DbiKDMBFuKC+1NFmZjsDI4xwl5Vv
	 tQpofyQKeRCKA+v0mtOhIaut90aBaJ/d2tAckjaluyVPD9ci5HkwixZXJLWNu8zg3m
	 xq1vpORen7R4F3DegPqXkd8GpdvV1C1DIp1GbIwxaxwgwWu9FQQju7hTVATv1RjoLv
	 zceW8XcfhfdhUiyFNy2aczvXddaJ2BhMhQTUkFs4WPg7sfDs6Em5Rhhdun2FoqFRo8
	 88Hxd35WsFB/Q9AKmpzeQ9iY2xRQkhomckKggnxejPgnEgiF0x+IzIpn69SB721zdR
	 /QPlAQv4vBsaQ==
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3ce886a2d5bso2712425ab.1;
        Wed, 19 Mar 2025 19:20:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVHbHIZ5gskjbV+DQmiLY4RQQs/+X6urb53hfxHEJQMCZnAsWrqscpxnZELk09uK13zJV7TV2RKDTglVhfOTg==@vger.kernel.org, AJvYcCVYyo8qPA/VD3Q3IjrDdt+e8JjTSULEQBFR5ni723mRKaqWeywjTG46GCol/LpPL3v0nfq4kD4235XZr8k=@vger.kernel.org, AJvYcCW6bbRvkBFEdTKH3cOCQBqd13P8+tVb4F2JixVK3OLFQzrOamLSw4ZrIFG1PT9RynLECXq/aLdoVbl6ROFnalATIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKGo6zwe0rXWW1sC4CTO3i6dG8uG4D465aW7gcxWZ5GCGNyvkl
	yCiCTGWxx1bteoiL6TybC5lvZl0YYr80CMXfmukkE6mMS5fLpQhS7I0UWa69OpI44c0Gblm2TJU
	qHWU1qbvmh13MyaXbJvYjAm4jwD4=
X-Google-Smtp-Source: AGHT+IGhOnhAnh34kZ+zv/L2skY/lReqXGHns8jGUDumOrwPKhbRTO/xpPIr4I5A0Xo+tU3bg7S05AvFMM4K1Vc/JgM=
X-Received: by 2002:a05:6e02:2183:b0:3d4:244b:db1d with SMTP id
 e9e14a558f8ab-3d58ebc0388mr17890885ab.6.1742437239151; Wed, 19 Mar 2025
 19:20:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250319213707.1784775-1-song@kernel.org> <20250319213707.1784775-2-song@kernel.org>
 <yrqgoc66te54tuffkrc74clsosiid2giw3gpc3kd3ddl4662tb@kiqh3ncfxwnl>
In-Reply-To: <yrqgoc66te54tuffkrc74clsosiid2giw3gpc3kd3ddl4662tb@kiqh3ncfxwnl>
From: Song Liu <song@kernel.org>
Date: Wed, 19 Mar 2025 19:20:28 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6AUiu4CryCkskHxe=BEX=LA9P81MWX1aGSN4j0bqTFXw@mail.gmail.com>
X-Gm-Features: AQ5f1Jri4qNGn9AAXiMELLGeAwcxC9xcx-0pWMyucSXtztpkXO4sg_80Fiu2hAc
Message-ID: <CAPhsuW6AUiu4CryCkskHxe=BEX=LA9P81MWX1aGSN4j0bqTFXw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] arm64: Implement arch_stack_walk_reliable
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, 
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com, 
	irogers@google.com, joe.lawrence@redhat.com, mark.rutland@arm.com, 
	peterz@infradead.org, roman.gushchin@linux.dev, rostedt@goodmis.org, 
	will@kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2025 at 3:35=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Mar 19, 2025 at 02:37:06PM -0700, Song Liu wrote:
> > +noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn c=
onsume_entry,
> > +                     void *cookie, struct task_struct *task)
> > +{
> > +     struct kunwind_consume_entry_data data =3D {
> > +             .consume_entry =3D consume_entry,
> > +             .cookie =3D cookie,
> > +     };
> > +     int ret;
> > +
> > +     ret =3D kunwind_stack_walk(arch_kunwind_consume_entry, &data, tas=
k, NULL, true);
> > +     if (ret =3D=3D -ENOENT)
> > +             ret =3D 0;
>
> Is this check redundant with the -ENOENT check in do_kunwind() which
> already converts ret to zero?

Indeed. This check is redundant.

Thanks,
Song

