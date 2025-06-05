Return-Path: <live-patching+bounces-1484-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2501ACEADB
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 09:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4168F3ABAC7
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 07:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23BE51ACEDC;
	Thu,  5 Jun 2025 07:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QgwopTEx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5DF4A0C;
	Thu,  5 Jun 2025 07:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749108737; cv=none; b=apGcelofj8pmGmTqLreK9pvr6iun5+EYqDQKlTzgbKUv2lrWrM5XuYQaQXzyX9yGsZtBwrTEzxRs6wFr8iez32gO4wdX2OWjjOJH8fi1onIgQHa36dSLT0RDa4+hhFDcq7twzi2wvu1kUjsFcf3q54GaFlP/3ceLDvVN5l8VK2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749108737; c=relaxed/simple;
	bh=bMHg3raD+5uQA+KTE2j/LtkuDrtsjODaZj3S951KNQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2GQ68qGEjeA9HEkE6+Otxz/1RM3IM835Dk9LGYlOsfJsjb0yO6U5puq9haSBgcFABIZ+54mVAMEtdLYTUBS/O4eBlsJGwwgsOaDBwJAItdevcxAsTnWJTc5gx9F3syVFVrrDDpG3kIXPszN1uLr0n5ZzCDXifKOTSGMHAj6uTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QgwopTEx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEE9C4CEE7;
	Thu,  5 Jun 2025 07:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749108735;
	bh=bMHg3raD+5uQA+KTE2j/LtkuDrtsjODaZj3S951KNQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QgwopTExwft/mrlqO9iTL834QZXBE8BdISNJ/64R9MD0cGRNLq3eKRLdrKKMIFUvr
	 zXefwCdvYbPSArnjrhCBuCT4fIvonHOrdKgT6SCXQMZd1fL59YciyLzB49e3a0amj/
	 n1F6/HMIFEz2GEkAJedDsTHiszi3qJNhyziPn/TgbB2ubpZM4zBhA0AD8IT4HHPAna
	 MOq5r8LBnGZ5t0MQVbNDA3gjJSQ1a3b55JGZpR+YLXzjceWw5WtP2jMKehnfqVvz5U
	 AhaDO4p3owF2eiuPsOaxuuyxVm6Q8RsqtxfHGAr/LeW3OTEYq/zQJfDy94AROPEtEQ
	 ScYgENgh7ef9A==
Date: Thu, 5 Jun 2025 00:32:12 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <hfs4v4frscapujmbdgpsbhnuvsqu3s6gltquyioatyeysed64e@izldzwjqsvu4>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <20250526182719.GR24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526182719.GR24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 08:27:19PM +0200, Peter Zijlstra wrote:
> On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> > +static void scan_for_insn(struct section *sec, unsigned long offset,
> > +			  unsigned long *insn_off, unsigned int *insn_len)
> > +{
> > +	unsigned long o = 0;
> > +	struct insn insn;
> > +
> > +	while (1) {
> > +
> > +		insn_decode(&insn, sec->data->d_buf + o, sec_size(sec) - o,
> > +			    INSN_MODE_64);
> > +
> > +		if (o + insn.length > offset) {
> > +			*insn_off = o;
> > +			*insn_len = insn.length;
> > +			return;
> > +		}
> > +
> > +		o += insn.length;
> > +	}
> > +}
> > +
> > +u64 arch_adjusted_addend(struct reloc *reloc)
> > +{
> > +	unsigned int type = reloc_type(reloc);
> > +	s64 addend = reloc_addend(reloc);
> > +	unsigned long insn_off;
> > +	unsigned int insn_len;
> > +
> > +	if (type == R_X86_64_PLT32)
> > +		return addend + 4;
> > +
> > +	if (type != R_X86_64_PC32 || !is_text_sec(reloc->sec->base))
> > +		return addend;
> > +
> > +	scan_for_insn(reloc->sec->base, reloc_offset(reloc),
> > +		      &insn_off, &insn_len);
> > +
> > +	return addend + insn_off + insn_len - reloc_offset(reloc);
> > +}
> 
> This looks like a rather expensive proposition; it will have to decode
> the section nr_reloc times.
> 
> Does it not make more sense to fully decode the section like 'normal' ?

Yeah, I'm not crazy about it either, but it at least keeps the pain
nicely localized to x86, and avoids pulling in struct instruction,
struct objtool_file, etc.

Also this typically doesn't need to be all that fast as this is only
done for changed functions, and only for a subset of relocations (those
which might be references to non-bundled data in a text section).

To give a general idea, in one of my tests, for a patch with 22
functions, it only calls scan_for_insn() 41 times.

-- 
Josh

