Return-Path: <live-patching+bounces-1463-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF828AC3E49
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 13:06:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7FBB1885AFB
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 11:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17ECC1D63C0;
	Mon, 26 May 2025 11:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eQV3tGFz"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7475D13A3ED;
	Mon, 26 May 2025 11:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748257607; cv=none; b=EXFxyOXoTcWcKDkZfCZdLYMGUFRhNjXGbKPWCw8tXQMypzYrUkSEX3rClRdml6TFYcGK+QWZk62ooalOWYNWQeSEpS5gnrQtu3UTNxNZJmFG9AwNaNyOk6etXGUPacU3ULIjAmMnRR1i8Zhu6lkQ8HuUXOxEdWXjbN/rL5K0x48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748257607; c=relaxed/simple;
	bh=Ean1VPfRB81uVPVay3RqkdUh3RGI7jVffLlfB096V60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fEk1n8qgxbMJKIljIXJvxHZvtkGCMLL2+kw896gMTbQ8eboN6FOvMnbnrqlPBbRAUDAx+pcsVqlxbYfRLK6Jh/LGAQ7pVjlP3mCZHHGhOes4VhUuSdlSXhyWhkO/27o/nqUqkIfZqA43nOuHgrkglBvjGBuNVC+wcno0bflA6+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eQV3tGFz; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XbgAsHBKZvPZSS34msp8ninxXYxoWbwGju3TTBvMeKU=; b=eQV3tGFzAHqEVT/nJd/xm8E047
	7Lip9Zx9jMHz34ILn/PC4V7R0/IxnbEldc58K///ZVwdahWMx6URtBaU9gux9rt2GalWd3LtXqawo
	FvwBw1wayhZLiEOcvnSjA/k81G/wXwXSrS5GEKJV3UxAwEKCUhSqP2vOB+cbVEw8JXYDMNHmldKQu
	FqV2QbIl9lccy7ON6aoy+Dz8wUrvLJrlvNUZrIw4qs92me3FzrQcLFcZ9IlXc2ri9kNy+iwvYXhx9
	jMhVeSeDbJOCv0pQ2/lSiTE3OSxeIwTSbQ5nt7QDj7kNpad0bB0TBcvHOxUkgwBmB319azRTb8Vy/
	DjRWQSqQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJVf9-00000001sER-0Ffe;
	Mon, 26 May 2025 11:06:35 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 834BE300472; Mon, 26 May 2025 13:06:34 +0200 (CEST)
Date: Mon, 26 May 2025 13:06:34 +0200
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
	Puranjay Mohan <puranjay@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH v2 42/62] kbuild,x86: Fix module permissions for
 __jump_table and __bug_table
Message-ID: <20250526110634.GO24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <9da1e9f592aadc8fbf48b7429e3fbcea4606a76a.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9da1e9f592aadc8fbf48b7429e3fbcea4606a76a.1746821544.git.jpoimboe@kernel.org>

On Fri, May 09, 2025 at 01:17:06PM -0700, Josh Poimboeuf wrote:
> An upcoming patch will add the SHF_MERGE flag to x86 __jump_table and
> __bug_table so their entry sizes can be defined in inline asm.
> 
> However, those sections have SHF_WRITE, which the Clang linker (lld)
> explicitly forbids combining with SHF_MERGE.
> 
> Those sections are modified at runtime and must remain writable.  While
> SHF_WRITE is ignored by vmlinux, it's still needed for modules.
> 
> To work around the linker interference, remove SHF_WRITE during
> compilation and restore it after linking the module.

*groan*

This and the following patches marking a whole bunch of sections M,
seems to suggest you're going to rely on sh_entsize actually working.

There was an ld.lld bug, and IIRC you need to enforce llvm-20 or later
if you want this to be so.

