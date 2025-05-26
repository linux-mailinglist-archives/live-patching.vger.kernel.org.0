Return-Path: <live-patching+bounces-1460-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 158EDAC3DEC
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 12:38:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C53613ADD36
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 10:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA78C1F4198;
	Mon, 26 May 2025 10:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TN2H/03/"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D6F2AE77;
	Mon, 26 May 2025 10:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748255917; cv=none; b=jC9Hz7xtOhd5mM6cGCLqYmkjxytgj5rWsFF9eqHb4hA+f+TqUXt8F+35qUqPWNXGm5wrBwcLblx/ITKIx+F6lInoKFpWyApt1crRJ0scu0bceDkUMFlQ6VBEEqayneb5I3rk51BseLhSdrxKZFASLOTBfkKMLj6aqijfOtERZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748255917; c=relaxed/simple;
	bh=9B4mWsZPbzEZ8Xs+cFKS5QSfxZ3kZC8bqmCUk3T4YdE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSoSd9/0YqXFBTLyjJLRO2F0bUa49N+WslA8nF3aJmXoLLgnQIxfQ0iseNT2yPzxETbS6yW/hC23TKXDngvgDdEQO1+wwjNEKl70HTi3nX8triwjnzvzAZLXS3Fd/aiuJQASlzHUM006sKw7O0MxASkexm0XrO6Vqlb9Etaj1zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TN2H/03/; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vlaOsRZCapfMxnw8GOIAPMbOZTsf1rhyIwhvYu2Fhms=; b=TN2H/03/JNwx3gaiD+MrDozJac
	1/yLsE3QrrZUeG7okDdGL/g4mCSfCYvzAO4rl4mIhEaJjF2NXUp0uavZPlQZqkmMKhjP6fkCH1CVX
	HkL2SH5Nkrjj80McLU8NerIAUciuOq4GLxaLNEtSazEL5NE/hbDcbIEeivh1/CNFMUMXTGzr+39Jh
	2+9CY3EoaskRetZdl84alDWZ0q0pXXw3KDF0b8lIQnamCzRUuzIlek8t8RCnyURnzew0kMmHPd85u
	0lsZ6OCsqufaQSgntdoBBxUovu8og/Gjz6mVHtGzNEmf/YarJsTSfes+D5fskcxe/IA5pEFSWRZvJ
	zBHPdOnA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJVDq-00000001rnl-3vT2;
	Mon, 26 May 2025 10:38:23 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 656C8300472; Mon, 26 May 2025 12:38:22 +0200 (CEST)
Date: Mon, 26 May 2025 12:38:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 28/62] objtool: Fix weak symbol hole detection for
 .cold functions
Message-ID: <20250526103822.GL24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <8ae052ab65412c0fc0359e780dc382f9feb53ace.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ae052ab65412c0fc0359e780dc382f9feb53ace.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:16:52PM -0700, Josh Poimboeuf wrote:
> When ignore_unreachable_insn() looks for weak function holes which jump
> to their .cold functions, it assumes the parent function comes before
> the corresponding .cold function in the symbol table.  That's not
> necessarily the case with -ffunction-sections.
> 
> Mark all the holes beforehand (including .cold functions) so the
> ordering of the discovery doesn't matter.

One of the things I have a 'todo' entry on, is rewriting all sections
that reference any one of these instructions.

That is, things like fentry, alternatives, retpoline, static_call,
jump_label.  Everything that can cause runtime code patching.

Once we are sure none of those sections will contain references to this
dead code, we can go and wipe the actual code. Perhaps fill it with a
UD1 instruction with some identifying immediate.

