Return-Path: <live-patching+bounces-1479-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61811ACE766
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 02:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FD7F1709B9
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 00:14:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65855136E;
	Thu,  5 Jun 2025 00:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bm7FPQmU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D310F2;
	Thu,  5 Jun 2025 00:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082447; cv=none; b=uzNY1/cJgrX5qYbca7Mj6yHmROd73U8jR3yiwktQ6/I+OEcf6fn72v/eXaPf9Mc8a4or7CNMzOKt5RDI6HQ+mFQh7yc49nhMk+BIql49cS/qUidb/JsrVCUDC4/vasI2KOnhWAdqN1tfUedjG7vQxEOpvBd7Ns8wG038NoMgphg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082447; c=relaxed/simple;
	bh=mlTrSydj2jGyyZ86G2tYuTK3bYvP3uK6PULl2Dx4/qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZidXv5KoYkgRldYjDM51qs0+u8utirP2a36BQgTtt9Iwxx9kc5iFFNj1+OLz61KCjIGPY9UBXmdG0zVemorcRNItg9qAUxoam9ypG5YnCFDNoC3/3FRzD95MFwy1txC5Fgk9rfZF9D7asZRDiC1/GYPBG/MmLrNsHuOnKD8HmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bm7FPQmU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B99C4CEE4;
	Thu,  5 Jun 2025 00:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749082446;
	bh=mlTrSydj2jGyyZ86G2tYuTK3bYvP3uK6PULl2Dx4/qU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bm7FPQmUuI3GFvJtimaBWKKYnP+5kcu2vGotHUVPS6okAV9GCMHt2V8Id0dQ1H59h
	 exH/+xmglG1ZZEFOyNGk+oaAM4+6gINmUqrh+vJ3yPV0eA0r+1KL+yIL8ANCHzzhve
	 PLEQYe0P3Ziyt39Ifu6mBnwpmrwKSdXJhgom4vZOS/wEa7Q5l6344157Hvi4q8X2++
	 m4ZVvYuwBPJC4a7zIHIJQwmXjbtyYZtS2B2rPkUyYsQYgGsBK3N9KSc0w6NdUilGFH
	 Cfo7P2+Ac/AhF7KqpBIVGd5gBeVsJqjDnnMlL2PORKyhWA2n7lDuS8xlpwwAzJX1lQ
	 7/+XmSIpNc7sg==
Date: Wed, 4 Jun 2025 17:14:03 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <u7g72fiqwvkxl3hpl3l2jmbfhez5o7sjtlpxf73or6wh545you@z3xpzkeg45yf>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526105240.GN24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 12:52:40PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:16:56PM -0700, Josh Poimboeuf wrote:
> > It's common to use --dryrun on binaries that have already been
> > processed.  Don't print the section skipping warnings in that case.
> 
> Ah, I rather like this warning, it gives me an easy check to see if the
> file has already been processed.
> 
> I typically do a OBJTOOL_ARGS="--backup" build and run dryrun debug
> sessions against those .orig files.

Ok.

Though, note that as of a few months ago, --backup no longer exists.  A
backup is now automatically created with --verbose.  But we can revive
it if you want.

-- 
Josh

