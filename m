Return-Path: <live-patching+bounces-1467-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 844F3AC43ED
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:47:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A63117A2A3
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF9C23E32D;
	Mon, 26 May 2025 18:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UDydgizv"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDE93A1CD;
	Mon, 26 May 2025 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748285233; cv=none; b=UtYN2uPR5b12/pEnls+8P6NOWKf63l9Qeaob055yqoG9i20icKkWUiQO0yeo9aPJv5hdu4iw6KyTug7WFDr0nykGWhUXe5+D8foMZZjO/QwAVFAjGgWvUa9H7oewVbyIlUy+xp3ax1CNtTGfbv0xwlAnbpKgVYF+fNVzW24jqKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748285233; c=relaxed/simple;
	bh=jzGOBQX+0zj/vrazzO8cJZjXMJAbGaqaTo7qCySR91U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNAmTAEk9/dsyB8D3rGEtZpYFsinZEcZfecx7f1O6Kw85pqpGL91wvt33uLnGm4UVa4B9W2IjsZDDjWVX4uSDQMODvPvUjrbxFrZg5OhdPmPfG1OVJxK5ckQn13bWrn0We7K9oaQcF7De9FVRQ7woOoahKXnjfUf0Fw7v1TwRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UDydgizv; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Sj87Za/iw31CvhVQt/q6ROhrTKLU0QPoaoZQ4SPAFIQ=; b=UDydgizvtNd6ngXdFh9zdV1+HH
	bhbFzv78I2717nxvEhD2EQvTxSZDh9phVsdjIunoYFITsDNFZVBrpYi56PT55WwcsdQMLzk+D4TeN
	FX47foL4z7ep3KTZ4vGYlhKTlA/bEXrBjflmrd4HI8RRlKncsgj4SOt9KHB5acJxoOJRM31btDVPE
	oB+qag2VA+i0SEDqubaXz1Pe0E7ds91/duT4Ez0dX+EOC+g3iLPdJ12fH3NeU9B9nuMgljb4SrjOU
	YMx0GtF3e5rC+eqiFwVsZGPxD0xFZDUTQ4BuDHpEW13GK5Ocg6Cv82s/yQR/lw9gs18N1lwuMX8m8
	Q6hdDxKg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJcqj-00000001yCo-1ehx;
	Mon, 26 May 2025 18:47:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E9AA5300472; Mon, 26 May 2025 20:47:00 +0200 (CEST)
Date: Mon, 26 May 2025 20:47:00 +0200
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
Message-ID: <20250526184700.GS24938@noisy.programming.kicks-ass.net>
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

On Fri, May 09, 2025 at 01:17:16PM -0700, Josh Poimboeuf wrote:
> +#define SEC_NAME_LEN		512
>  #define SYM_NAME_LEN		512
>  

> +static int validate_ffunction_fdata_sections(struct elf *elf)
> +{
> +	struct symbol *sym;
> +	bool found_text = false, found_data = false;
> +
> +	for_each_sym(elf, sym) {
> +		char sec_name[SEC_NAME_LEN];
> +
> +		if (!found_text && is_func_sym(sym)) {
> +			snprintf(sec_name, SEC_NAME_LEN, ".text.%s", sym->name);

So given SYM_NAME_LEN is 512, this SEC_NAME_LEN should be at least 6
more, no?

> +			if (!strcmp(sym->sec->name, sec_name))
> +				found_text = true;
> +		}
> +
> +		if (!found_data && is_object_sym(sym)) {
> +			snprintf(sec_name, SEC_NAME_LEN, ".data.%s", sym->name);
> +			if (!strcmp(sym->sec->name, sec_name))
> +				found_data = true;
> +		}
> +
> +		if (found_text && found_data)
> +			return 0;
> +	}
> +
> +	ERROR("changed object '%s' not built with -ffunction-sections and -fdata-sections", elf->name);
> +	return -1;
> +}

