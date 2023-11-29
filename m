Return-Path: <live-patching+bounces-56-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B45E7FDB5C
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 16:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44EF5281EA4
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 15:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C1D38DFA;
	Wed, 29 Nov 2023 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RmoM01It"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B76A19BA;
	Wed, 29 Nov 2023 07:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=PKsQMbsN0QWAKv2jNMdgGwhjrNCW6BNWUDQ6YRpuRlU=; b=RmoM01ItmuKnUSVmpIbPI2bH9v
	mhHqH5GExVaD/VgR54BoKqfFiSHoIjiv8yR8/mTDccz83ix4DJdUG1hMwyWu7kWY5gTxuJUQZZDG3
	ScImQjVoDyS6rAZ7PX04g5yKujaPDgidrgRG8UyAyFBHPKp0A526tzffKHkqbkMh3Qe1h6wHiahLw
	ORT7OLZykfqOnoL9DSsTc/DA0rxSJtyptnBJiHoHG1LchC+ySlRIpgR7VfXVBQTurWfvb946VW7vG
	+DUwO3w4ytXX1siY+Mababr6ncli+KGytLrsQqBeH3gX2KOBqyk9H/+6GlBgNtVmLi+Samj6OzwfL
	EsKQQaOQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r8MSA-00DWNO-Uk; Wed, 29 Nov 2023 15:26:18 +0000
Date: Wed, 29 Nov 2023 15:26:18 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Livepatching <live-patching@vger.kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Attreyee Mukherjee <tintinm2017@gmail.com>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: Re: [PATCH 0/2] Minor grammatical fixup for livepatch docs
Message-ID: <ZWdYGrhTYFzG5BZq@casper.infradead.org>
References: <20231129132527.8078-1-bagasdotme@gmail.com>
 <874jh4pr8w.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874jh4pr8w.fsf@meer.lwn.net>

On Wed, Nov 29, 2023 at 07:29:35AM -0700, Jonathan Corbet wrote:
> Bagas Sanjaya <bagasdotme@gmail.com> writes:
> 
> > I was prompted to write this little grammar fix series when reading
> > the fix from Attreyee [1], with review comments requesting changes
> > to that fix. So here's my version of the fix, with reviews from [1]
> > addressed (and distinct grammar fixes splitted).
> 
> How is this helpful?  Why are you trying to push aside somebody who is
> working toward a first contribution to the kernel?  This is not the way
> to help somebody learn to work with the kernel community.

This is not the first such "contribution" from Bagas recently.

https://lore.kernel.org/linux-doc/20231121095658.28254-1-bagasdotme@gmail.com/

was as a result of
https://lore.kernel.org/linux-xfs/87r0klg8wl.fsf@debian-BULLSEYE-live-builder-AMD64/

I didn't say anything at the time, but clearly I should have squelched
this bad behaviour by Bagas before he did it to a newbie.

Bagas, find your own project to work on.  Don't steal glory from others.

