Return-Path: <live-patching+bounces-1481-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E3D2ACE77C
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 02:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73D463A94D8
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 00:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1BE7494;
	Thu,  5 Jun 2025 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTmnug0l"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DB82F43;
	Thu,  5 Jun 2025 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082935; cv=none; b=INlYl1qNOTkB2lQ5Z+7kSVIZar/7k6UfX506WNNmIjmGOgB46UAgRxpkrY/wsIpjCxjzm20wE0MfIIxuWxbJZOHPDL8rJ2cW6Ll/WZ4T/1UkMAcQyZw1f41ydZb2W7Mc8NLwYYXkSCha0Uofi9sbtnvPZb/ddiAhkUwPJklc/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082935; c=relaxed/simple;
	bh=6/q73xe5zRQSNc9a93fuAwlkT85IVrJBXRq8AT/arok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxaBvHGSIvoyRByBMafQ1jIi8U1TE2FzJC1nRbfBF7ILdvT9MJw+6fS2wqYkvdgI4wJpzY8+naECDKUaZ37rm4TfTEYwi0C6I/cEcOA1P9rPEUMo4dnWURihZ8pwZ8Lv5f6AdHhhrWZc+WqmKfgRJtD+YtNu75Y9kpVBfX+cpfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTmnug0l; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83EA0C4CEE4;
	Thu,  5 Jun 2025 00:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749082935;
	bh=6/q73xe5zRQSNc9a93fuAwlkT85IVrJBXRq8AT/arok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTmnug0l3MftKjinfBDulJrcGKbRxNQ0297A8tjDgtGxXhjLrJyeU8orTu13wiiVB
	 y7T/4rdZwfcBt/aYavkk3wejw0kVJLf6+KBKX1ZRF1efQJs92CqEFUxsXkHJpt2WSk
	 s6pYJooP58W9e7TLGt3C6wgWkLtkRFf8ExEwd1u+/Xe0dQ+U/vX3p92h2I3uGNVEtV
	 awZByAbb4r7sVpAXVytyWGZW2XCkYTNTDLPQJuiKrfBJfTGdPl2DfEOaquV2XCnJ6x
	 2zzUxfpzPWJGC3/mWjkQznX8T4acp06IxzB/oI9LcYryU1NA1GgzLAd0Vbc+Lk2KJe
	 /fxfLw1rDwcWg==
Date: Wed, 4 Jun 2025 17:22:11 -0700
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
Message-ID: <cv2xosjolcau7n3poyymo3yodhl4cokwmju53d3rwfsqhkbqym@rsvd5oqqhczk>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <9da1e9f592aadc8fbf48b7429e3fbcea4606a76a.1746821544.git.jpoimboe@kernel.org>
 <20250526110634.GO24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526110634.GO24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 01:06:34PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:17:06PM -0700, Josh Poimboeuf wrote:
> > An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> > __bug_table so their entry sizes can be defined in inline asm.
> > 
> > However, those sections have SHF_WRITE, which the Clang linker (lld)
> > explicitly forbids combining with SHF_MERGE.
> > 
> > Those sections are modified at runtime and must remain writable.  While
> > SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> > 
> > To work around the linker interference, remove SHF_WRITE during
> > compilation and restore it after linking the module.
> 
> *groan*
> 
> This and the following patches marking a whole bunch of sections M,
> seems to suggest you're going to rely on sh_entsize actually working.
> 
> There was an ld.lld bug, and IIRC you need to enforce llvm-20 or later
> if you want this to be so.

Hm, ISTR this working with clang 18, I'll go test that again.

-- 
Josh

