Return-Path: <live-patching+bounces-1468-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C797AC43F1
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BBA91794D5
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 373551BF33F;
	Mon, 26 May 2025 18:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lbVUVTh8"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB19F9E8;
	Mon, 26 May 2025 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748285450; cv=none; b=a1Ekyap+bi037D2+PpiIkllirCB+tBR9bu3CtCNgO4ZXiOhhnXPXp1poPgA53Kk/vtlza0OFOSyw3O9MZow5LXBSGr9scsi/NQ+pXgU5uuPcHjVFf0Mq9UVUxkrXAAOWTw0dhs0xm1eeU08Qbpy+G94HHK5InQhOfj7T/PvxDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748285450; c=relaxed/simple;
	bh=6I2japGRL29Doq8vR4/LHC+Vr/HCtO2hinF9uhD4ORU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rR2W+Df1CORpBJwQBRS4mpWY9wpxsnjas9n8unY+jjxl8krR5yN1DyAP2668Me/JNvE2MNl91kSCBgVE803kXNsEY7cE2jmMXG68ZQ1PYp7sxbn/+lp3f3dme1eF4lsjmMOp1WzvcyH3EBvbjv/l4KKPBeCVesz8oSCboVlK5mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lbVUVTh8; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SK3aHAOv8ecTNWNrqWK1xeJERFP/KDZ9DQAlW0Tb6P8=; b=lbVUVTh8BKMaBj8UVDxJ30wy+U
	p+2wZTI8PNdRCpDtFt0NUjUffEtwZ/bSbbEeCqF+grgjTb3IyTXIUe5EK1THS/AuqcrQToD0GLkVk
	fo6JTWJrbmVq+Pnh2ORYXCZ47/BdRlAjJRCKUe9ZKPumw0VLv8cIrgUOPqrIVDjH83bHFsfI5+UAY
	HlWeOLjyF056BAy5XPvOqXwTJLvtGAOWX1bYUSWqB0aSRj7oFVn3jvoKl6QcVeiVSfzV9ojYnoXGu
	B4oScf4WzAHHqlVedcINnZIWp6RXaYnN/KjrDdxil/QUkVpeTdoPU3CundPXKoaZg0aPweL0xzQGP
	GgGMxKhQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJcuH-00000001yEu-19Pa;
	Mon, 26 May 2025 18:50:41 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D3325300472; Mon, 26 May 2025 20:50:40 +0200 (CEST)
Date: Mon, 26 May 2025 20:50:40 +0200
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
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
Message-ID: <20250526185040.GT24938@noisy.programming.kicks-ass.net>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>


Let me hand you a fresh bucket of curlies, you must've run out :-)

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:

> +static struct symbol *first_file_symbol(struct elf *elf)
> +{
> +	struct symbol *sym;
> +
> +	for_each_sym(elf, sym) 

{

> +		if (is_file_sym(sym))
> +			return sym;

}

> +
> +	return NULL;
> +}
> +
> +static struct symbol *next_file_symbol(struct elf *elf, struct symbol *sym)
> +{
> +	for_each_sym_continue(elf, sym)

{

> +		if (is_file_sym(sym))
> +			return sym;

}

> +
> +	return NULL;
> +}

> +static bool is_special_section(struct section *sec)
> +{
> +	static const char * const specials[] = {
> +		".altinstructions",
> +		".smp_locks",
> +		"__bug_table",
> +		"__ex_table",
> +		"__jump_table",
> +		"__mcount_loc",
> +
> +		/*
> +		 * Extract .static_call_sites here to inherit non-module
> +		 * preferential treatment.  The later static call processing
> +		 * during klp module build will be skipped when it sees this
> +		 * section already exists.
> +		 */
> +		".static_call_sites",
> +	};
> +
> +	static const char * const non_special_discards[] = {
> +		".discard.addressable",
> +		SYM_CHECKSUM_SEC,
> +	};
> +
> +	for (int i = 0; i < ARRAY_SIZE(specials); i++)
> +		if (!strcmp(sec->name, specials[i]))
> +			return true;
> +
> +	/* Most .discard sections are special */
> +	for (int i = 0; i < ARRAY_SIZE(non_special_discards); i++)

{

> +		if (!strcmp(sec->name, non_special_discards[i]))
> +			return false;

}

> +
> +	return strstarts(sec->name, ".discard.");
> +}
> +
> +/*
> + * These sections are referenced by special sections but aren't considered
> + * special sections themselves.
> + */
> +static bool is_special_section_aux(struct section *sec)
> +{
> +	static const char * const specials_aux[] = {
> +		".altinstr_replacement",
> +		".altinstr_aux",
> +	};
> +
> +	for (int i = 0; i < ARRAY_SIZE(specials_aux); i++)

{

> +		if (!strcmp(sec->name, specials_aux[i]))
> +			return true;

}

> +
> +	return false;
> +}
> +

And possibly more..

