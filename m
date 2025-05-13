Return-Path: <live-patching+bounces-1429-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09717AB5E04
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 22:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8313A174F7F
	for <lists+live-patching@lfdr.de>; Tue, 13 May 2025 20:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C81D2629D;
	Tue, 13 May 2025 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uvbHGQ/H"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78CA4C6C;
	Tue, 13 May 2025 20:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747169136; cv=none; b=uXmEz9P1EToKdRPubwEn0gFVOCKbLkIXbLRm2th/YgIoGMshdLsmIb3e7c1MDDvXgS7SrH1yhP71qiCboTBrbK9yw84Pv8XgbrRLrXdG0hktI012PbMLFQGvczAlWIM5OoLbSjQ1OM6HGFppOL7lxNEEejcwMa6wrw4rYQ3wwbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747169136; c=relaxed/simple;
	bh=Zr40m+obX2BijZL/amVykCW4pZ4tq0OAwkE31AcQNSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iEGf4+2xRPcsMfat3tVA3Ltve9axqxtvskl8YB/Z7SX3r7IVlCvXmgZxeC3dKzlxI5TR8lmTBl85tE6HnzzSSfMBLYMQNmq5eDaIIdchZ+VdglMlQ0OtoNVKvuMT96x36h/Oft6D6LMTypgD427C+AMAKifGUY3iCbqP086qSNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uvbHGQ/H; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52842C4CEE4;
	Tue, 13 May 2025 20:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747169135;
	bh=Zr40m+obX2BijZL/amVykCW4pZ4tq0OAwkE31AcQNSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uvbHGQ/Ho395vZnTXEuh/09ToFj6q5fPq4it/Tu+16t3oAUPMJnvuUc9p4F6hgVtw
	 UsSg0vt75dacJPl2cuNpQlhzTZb7z9TIzTp+Fe8ORuuhj9lCfGPVQ1HenYHFwzqvsI
	 ohm25TwZmAhaKLcTcK8B40jdVbztAUCExKP1geIe27rqMiGaMilou7IS7LZvZTTlrZ
	 MWglBCPDPioJR3vlkDottojuaU36RAKFWk48wwe5X9/LYHaQsSnRAJiS8tNeLGCSqd
	 lIAIrItcgyla/IF/BPt4wEl1pCzhwq3f4ON7pK53aUc7kMU5lneGaKGE2Cgnpddw4W
	 Y5Rrb4iZpBzRw==
Date: Tue, 13 May 2025 13:45:32 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: laokz <laokz@foxmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, 
	Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>, 
	Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <c63auxjhv2lanvir4rryy3kp6qpni4q7p62ng6hnvoo4w4idvf@i4mx3asblvis>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <tencent_8AACB6DF7CFB7A9826455C093C0903B15207@qq.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <tencent_8AACB6DF7CFB7A9826455C093C0903B15207@qq.com>

On Tue, May 13, 2025 at 10:49:59PM +0800, laokz wrote:
> On 5/10/2025 4:17 AM, Josh Poimboeuf wrote:
> > +
> > +#define sym_for_each_reloc(elf, sym, reloc)				\
> > +	for (reloc = find_reloc_by_dest_range(elf, sym->sec,		\
> > +					      sym->offset, sym->len);	\
> > +	     reloc && reloc_offset(reloc) <  sym->offset + sym->len;	\
> > +	     reloc = rsec_next_reloc(sym->sec->rsec, reloc))
> 
> This macro intents to walk through ALL relocations for the 'sym'. It seems
> we have the assumption that, there is at most one single relocation for the
> same offset and find_reloc_by_dest_range only needs to do 'less than' offset
> comparison:
> 
> 	elf_hash_for_each_possible(reloc, reloc, hash,
> 				   sec_offset_hash(rsec, o)) {
> 		if (reloc->sec != rsec)
> 			continue;
> 		if (reloc_offset(reloc) >= offset &&
> 		    reloc_offset(reloc) < offset + len) {
> less than ==>		if (!r || reloc_offset(reloc) < reloc_offset(r))
> 					r = reloc;
> 
> Because if there were multiple relocations for the same offset, the returned
> one would be the last one in section entry order(hash list has reverse order
> against section order), then broken the intention.

Right.  Is that a problem?  I don't believe I've ever seen two
relocations for the same offset.

-- 
Josh

