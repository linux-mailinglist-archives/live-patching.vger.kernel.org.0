Return-Path: <live-patching+bounces-1477-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 30B12ACE755
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 01:57:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1ECA77A828E
	for <lists+live-patching@lfdr.de>; Wed,  4 Jun 2025 23:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A583122DA0B;
	Wed,  4 Jun 2025 23:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ufGXMi3H"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A38A7082D;
	Wed,  4 Jun 2025 23:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749081418; cv=none; b=ezSJL0Vr0gojDQIb8YotJpfjwg7aB6BLqJWRjzVNFzizTpYOa8Rhs4n3GYY+6wyS+LpVga3iLfhsniwX16wY1XEv1dp2MazNm97u303swcZOsgJrUU2BpYdRvrHSoClB8VJdX/TMRtrsizCpPeYqxAO5oenFWSwnoobGxdW+UvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749081418; c=relaxed/simple;
	bh=vR8ihtjIY260/n5Kw5R0h+UZ0sam1j/PGAaSZ8dp7Wk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQjymgMKntTTBgavih5IzDd6mobeckWuGueeCaN+Q/ZMlHSoJj3eFBR7oFIecfRlW4NR7sLV7cYZoL5Um8R0B4CVqXPVOCzFEaB3S1YpXhZ9NbhNQRaUEp0Sw6xKEhdlO87J41ju8lvIpqL/w2UvLmKSNANe/ZLHvc2uYEG3t+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ufGXMi3H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89773C4CEE4;
	Wed,  4 Jun 2025 23:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749081417;
	bh=vR8ihtjIY260/n5Kw5R0h+UZ0sam1j/PGAaSZ8dp7Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ufGXMi3HSkglT4W7QDxjOqroVcGIBAe5B+G/YxqRtUhbhNgstnt7Waq3QiLKLxXos
	 3iz0+MjcUwzM7W4LqU1U5CKH9QIVERgQBB7P2ma+4YKj0MsrvYwkP1jWxlduxl5aAL
	 Id6eQ+egMt58FZZZrIcGzH0PCSqc9vlMTQYC3blGe0lmmvsUjJj6Bmrpw6o8hxAbMQ
	 ZchjpEQUEmFx+DjLEKOHdPBjhG2puFrz3qySgqTdu6vf/GnZwWB7YkzWa1cLlEEmL5
	 /dl713VIKyCW+2AGq5Zskz3JPVAaFq9ff+DP26BwvD8mYBoAL5WqD6702BU6zTqJrV
	 pnSUYrq69Kp+g==
Date: Wed, 4 Jun 2025 16:56:54 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 28/62] objtool: Fix weak symbol hole detection for
 .cold functions
Message-ID: <dqetdbtdhkipt5ighko7omvupe34zo76jky6digezrlra2madv@5hrau7wxbcvm>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <8ae052ab65412c0fc0359e780dc382f9feb53ace.1746821544.git.jpoimboe@kernel.org>
 <20250526103822.GL24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526103822.GL24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 12:38:22PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:16:52PM -0700, Josh Poimboeuf wrote:
> > When ignore_unreachable_insn() looks for weak function holes which jump
> > to their .cold functions, it assumes the parent function comes before
> > the corresponding .cold function in the symbol table.  That's not
> > necessarily the case with -ffunction-sections.
> > 
> > Mark all the holes beforehand (including .cold functions) so the
> > ordering of the discovery doesn't matter.
> 
> One of the things I have a 'todo' entry on, is rewriting all sections
> that reference any one of these instructions.
> 
> That is, things like fentry, alternatives, retpoline, static_call,
> jump_label.  Everything that can cause runtime code patching.
> 
> Once we are sure none of those sections will contain references to this
> dead code, we can go and wipe the actual code. Perhaps fill it with a
> UD1 instruction with some identifying immediate.

Yeah, that would be nice.

-- 
Josh

