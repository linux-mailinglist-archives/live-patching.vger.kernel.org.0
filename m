Return-Path: <live-patching+bounces-1298-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40F32A68037
	for <lists+live-patching@lfdr.de>; Wed, 19 Mar 2025 00:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3B181770BC
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 23:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AFB81E832D;
	Tue, 18 Mar 2025 23:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaweLj0Q"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C0C1FAA;
	Tue, 18 Mar 2025 23:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742338836; cv=none; b=umk7BKVx783ZtCen5FTIlGSdDbA2sr4UZSsWRn820ekS81NWtioKMZPk4ZZhOBxxTDkzmaF1ijVQjM+LG7V2mDsGnOFEO5OT8ajnr0sHuZ1llmQL8tvnz8Ax54cy7g2P4gClgAfgoIczXk+RSjMDydT7NoJ43gu/giKGOOYdUFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742338836; c=relaxed/simple;
	bh=Dr5JLgo/lrzaiY2c96lg9HAJ5ExgQ1teNDMLECNkAPQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Di7IpRCum4hijsjCOLQfKnftlfR3mASAU5wzUkaw79lUzRB+5R2PTJfDbNnjfS4wkXXOlzoW5B9OXm/3vx04SaOY2+KPG2gU2gsOhhOYO1MN1g1lZj7+5Ox/PaRLtyW0nSlGcE8j6yHzF59ySVV0Aqfy/J0Kh9BVQvoCjsohfTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaweLj0Q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D91C4CEDD;
	Tue, 18 Mar 2025 23:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742338835;
	bh=Dr5JLgo/lrzaiY2c96lg9HAJ5ExgQ1teNDMLECNkAPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qaweLj0QPu0L9CSUDZXj53BHV7x204cZV4Je65s0qsvQgiV3LfKmgPTQcN6v6Ecmg
	 8I+TT9ZvhQ9hfqB1u/wwGfg7gA//xpC5Uu9DFbvTI/rjyRZ7GvRFd/biXCqTPFu7Qc
	 +s0G4yml9DQFIbkXF77D3qwGY4L/bB9R6Xo+zn1gErqhF72GSfVeo5iv3iOkx8vl4M
	 KnQJMSgOuRXO1HranIi5nLgmQL1epTPYKu6b8Jsu9ImxUFrqJMvp+aiOIXoVZ14aM5
	 MLg7jB8EVBzM5UxGS2/1cazgJSJZLTIGzNiQTIc+SJ+w+zmWVr8cx1+3geDmUhembm
	 JrEOONPr7+Rcg==
Date: Tue, 18 Mar 2025 16:00:32 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org, indu.bhagat@oracle.com, 
	puranjay@kernel.org, wnliu@google.com, irogers@google.com, joe.lawrence@redhat.com, 
	mark.rutland@arm.com, peterz@infradead.org, roman.gushchin@linux.dev, 
	rostedt@goodmis.org, will@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <ox4c6flgu7mzkvyontbz2budummiu7e6icke7xl3msmuj2q2ii@xb5mvqcst2vg>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-2-song@kernel.org>
 <iajk7zuxy7fun7f7sv52ydhq7siqub3ec2lmguomdd3fhdw4s2@cwyfihj3gvpn>
 <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW4A73c0AjpUwSRJ4o-4E6wpA9c5L0xWaxvHkJ3m+BLGVA@mail.gmail.com>

On Tue, Mar 18, 2025 at 01:14:40PM -0700, Song Liu wrote:
> >
> > See for example all the error conditions in the x86 version of
> > arch_stack_walk_reliable() and in arch/x86/kernel/unwind_frame.c.
> 
> I guess I missed this part:
> 
> diff --git i/arch/arm64/kernel/stacktrace.c w/arch/arm64/kernel/stacktrace.c
> index 69d0567a0c38..3bb8e3ea4c4b 100644
> --- i/arch/arm64/kernel/stacktrace.c
> +++ w/arch/arm64/kernel/stacktrace.c
> @@ -268,6 +268,8 @@ kunwind_next(struct kunwind_state *state)
>         case KUNWIND_SOURCE_TASK:
>         case KUNWIND_SOURCE_REGS_PC:
>                 err = kunwind_next_frame_record(state);
> +               if (err && err != -ENOENT)
> +                       state->common.unreliable = true;
>                 break;
>         default:
>                 err = -EINVAL;

I still see some issues:

  - do_kunwind() -> kunwind_recover_return_address() can fail

  - do_kunwind() -> consume_state() can fail

  - even in the -ENOENT case the unreliable bit has already been set
    right before the call to kunwind_next_frame_record_meta().

-- 
Josh

