Return-Path: <live-patching+bounces-1483-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A2BACE8CD
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 06:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FF581736A2
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 04:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E807386337;
	Thu,  5 Jun 2025 04:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TE3SRtVn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62B536D;
	Thu,  5 Jun 2025 04:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749096061; cv=none; b=TXBlXUZ1u21I6BwTBLdGVSvtzjdyYLF2CD5yFZT2k5JWErdcATnok789278L93uvEPNNjBvSHLl/IdxQEqg+UHLAgNWeRx40XisBukg7oQgGcsaawyCCkT2t6t28Y4NBL6ddevL+t8CovyU59dP65W9YHamFbZ2uozr77PTk7Gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749096061; c=relaxed/simple;
	bh=FXBbPzAAhSovRjwex5dKZ+yjnaMLwgjnsSIoY9sDE1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLn5EASLmFnAhyRTZaKoij4B3yRmumZhnD/5eiyf2QC+OiA1fquMWrKZ+h3KLEP/kngaqfaSojnyj8T03Y9idcoskz00Gctr7MWcYFhpZYJwXQnja0G11MUc3GHUp4mEQi+yw21sXYj0iUbrNcRHYTn/mDXQ/MhoMT2n+GYJ01s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TE3SRtVn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B8AC4CEE7;
	Thu,  5 Jun 2025 04:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749096061;
	bh=FXBbPzAAhSovRjwex5dKZ+yjnaMLwgjnsSIoY9sDE1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TE3SRtVn/ST+6NYt67ULRZx7tLW0hM+eND8+c6xr+qyGpmaewhWnLTwJ27qjghKQK
	 57GwktKqixOBYHWf7bTWA7bqVaaEq2wDr9YNXva+rIr4eplsrmGsedyY00N567BvPa
	 DekU3wZEL5OImZrkEeCui9XbMAH6fnWt1yx5frXEpM++4mUAl46PR/8EhLURhc4azL
	 /ctQkn9JztINDO49ZNJwVkbpUNG+3NxurCG990GJkwo8YZvYtGwJqNB1KhjMRm1jxj
	 OTIn6gmUznXonsOsg9veOK70Z8zhobwNiwExdqMwe+jQpSc6JfCLnQCL1/PoVOtYuS
	 7dGXV4AeYtWIw==
Date: Wed, 4 Jun 2025 21:00:58 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v2 42/62] kbuild,x86: Fix module permissions for
 __jump_table and __bug_table
Message-ID: <bibraqfzt22adfii3emorei7lobdhjnmfrfv3n4cd7f22k73s4@jbxclgfc6fgi>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <9da1e9f592aadc8fbf48b7429e3fbcea4606a76a.1746821544.git.jpoimboe@kernel.org>
 <20250526110634.GO24938@noisy.programming.kicks-ass.net>
 <cv2xosjolcau7n3poyymo3yodhl4cokwmju53d3rwfsqhkbqym@rsvd5oqqhczk>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cv2xosjolcau7n3poyymo3yodhl4cokwmju53d3rwfsqhkbqym@rsvd5oqqhczk>

On Wed, Jun 04, 2025 at 05:22:15PM -0700, Josh Poimboeuf wrote:
> On Mon, May 26, 2025 at 01:06:34PM +0200, Peter Zijlstra wrote:
> > On Fri, May 09, 2025 at 01:17:06PM -0700, Josh Poimboeuf wrote:
> > > An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> > > __bug_table so their entry sizes can be defined in inline asm.
> > > 
> > > However, those sections have SHF_WRITE, which the Clang linker (lld)
> > > explicitly forbids combining with SHF_MERGE.
> > > 
> > > Those sections are modified at runtime and must remain writable.  While
> > > SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> > > 
> > > To work around the linker interference, remove SHF_WRITE during
> > > compilation and restore it after linking the module.
> > 
> > *groan*
> > 
> > This and the following patches marking a whole bunch of sections M,
> > seems to suggest you're going to rely on sh_entsize actually working.
> > 
> > There was an ld.lld bug, and IIRC you need to enforce llvm-20 or later
> > if you want this to be so.
> 
> Hm, ISTR this working with clang 18, I'll go test that again.

You're right, looks like sh_entsize is getting cleared by the linker
with my Clang 18.  I guess I tested with newer Clang.

"objtool klp diff" fails with:

  vmlinux.o: error: objtool: .discard.annotate_insn: unknown entry size

So yeah, non-buggy linker is already being enforced, though I should
probably make the error more human friendly.

-- 
Josh

