Return-Path: <live-patching+bounces-1485-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75FC3ACEADE
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 09:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 282E0176FA7
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 07:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F017A1AF0B4;
	Thu,  5 Jun 2025 07:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rH83iZjA"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B754A0C;
	Thu,  5 Jun 2025 07:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749108782; cv=none; b=pl+vKOylLKbo8efLX2acHcUIhWbgmiMsBxEE0H+Qhs7vNTTKr3Z0Z+q8/URpjtvsIn0JEO9avF7+zWjPn38opLfvJi24NgfeImQ5ScWjba/mOARAxmD3OsaCWrPvOYSGRDlj9Fj8P9h7c76TWEHkC1RtKaW5lJILHjKWvP9bjnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749108782; c=relaxed/simple;
	bh=3PBNswoyKjjFxf/BpnvxMZtbVg31uA1+ho9i9eFV6Pw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SV4Eg0jAkszJ77leqpTL9x6QGrreYePCUs+JmigY0KfH3Ec14UVmNzC4T2Kg7Ow9rIGvW7VIZlqyf1mYUhjnVuPWDrHW2Gn1ERHzeEdDp1eEdZsYEazRm//+CYk3FSw3JeC+to8pvw4CtD3+CLi69RR5RXue862wmUAKMQb+rgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rH83iZjA; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lbxYukemSIVlu2IE2KURMLDhS0xfEDglHp/2jIcXn7M=; b=rH83iZjAN4SLbWHAPY8O248KVb
	D4J6QpTPWu+AD1ScFl9d1kqIfKY5hkDSid1oint8Y0cifxhhrIyTShH3WWk4+96NZo7sYx/45PZcG
	Mbl0P9Bi1lXZO3bkuC21NKJa3gwL6CjXf5Ff92vziu306OJHBKNvLwFAx+0604AG0F85bcPghd9J6
	3zYJm9pvC6xMiR1wIqKGpkfQPdnRUEQOn8WX4mM+Lz2rRiX80mkLHB+63BMwg6afAWD98Dwi0Jx79
	Eu+En+TZivrjDJHv+Bv5CZlrg8C6ksvfOspX62hgKD2Oo7GUt/r+n09m+dw3E95jP3EgdlApQqYcb
	M43D9Q2A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uN55j-0000000160b-3EFT;
	Thu, 05 Jun 2025 07:32:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CF06F3005AF; Thu,  5 Jun 2025 09:32:46 +0200 (CEST)
Date: Thu, 5 Jun 2025 09:32:46 +0200
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
Subject: Re: [PATCH v2 32/62] objtool: Suppress section skipping warnings
 with --dryrun
Message-ID: <20250605073246.GM39944@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <7eccdb0b09eff581377e5efab8377b6a37596992.1746821544.git.jpoimboe@kernel.org>
 <20250526105240.GN24938@noisy.programming.kicks-ass.net>
 <20250528103453.GF31726@noisy.programming.kicks-ass.net>
 <ycpdd352wztjux4wgduvwb7jgvt6djcb57gdepzai2gv5zkl3e@3igne4ssrjdm>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ycpdd352wztjux4wgduvwb7jgvt6djcb57gdepzai2gv5zkl3e@3igne4ssrjdm>

On Wed, Jun 04, 2025 at 05:19:51PM -0700, Josh Poimboeuf wrote:
> On Wed, May 28, 2025 at 12:34:53PM +0200, Peter Zijlstra wrote:
> > On Mon, May 26, 2025 at 12:52:40PM +0200, Peter Zijlstra wrote:
> > > On Fri, May 09, 2025 at 01:16:56PM -0700, Josh Poimboeuf wrote:
> > > > It's common to use --dryrun on binaries that have already been
> > > > processed.  Don't print the section skipping warnings in that case.
> > > 
> > > Ah, I rather like this warning, it gives me an easy check to see if the
> > > file has already been processed.
> > > 
> > > I typically do a OBJTOOL_ARGS="--backup" build and run dryrun debug
> > > sessions against those .orig files.
> > 
> > Turns out, you already broke this.. :-(
> > 
> > I'm now having a case where objtool fails on vmlinux.o and make happily
> > deletes vmlinux.o and I'm left empty handed.
> > 
> > Let me go resurrect --backup
> 
> Yeah, as I just mentioned in that other email, --verbose should give you
> what you need.  It also prints the cmdline args, which is nice.
> 
> But also, feel free to resurrect --backup, or you can yell at me to do
> it as the backup code changed a bit.

I have the patch somewhere, failed to send it out. I'll try and dig it
out later today.

