Return-Path: <live-patching+bounces-1465-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20879AC43AE
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 20:25:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2D3E1898A12
	for <lists+live-patching@lfdr.de>; Mon, 26 May 2025 18:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46DA21F4281;
	Mon, 26 May 2025 18:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kVuzc07g"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35791C5F06;
	Mon, 26 May 2025 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748283912; cv=none; b=LA1qsemLjZfjeWOhSCS5gdwoP5wgI0F1WeQ7a/SSUB2S/YLLF3s2Jblc4BhQmtApl3VegZ3wKHoENQVm4YVyrWynIzBVv/ksPnMEpNlZp0bBY3iozYLJuBAm0TlHsG2H872h7ub6bKtWvzpvul9j21UkVCL5PBlBgphI1PGQghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748283912; c=relaxed/simple;
	bh=swOmcwtXzxKsoxKB4RPs4Youlhi4JHrj7pbmGvHHadA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWnRc0GqTHlhR+qJch4GjbsCfPfay7JXXtKZg4Akhop/N435lxIWse+KGzf/KMSBHywJZ8tW/BQgpGubh9LiUdT9hdPMirZ83PqSCBHp705Bm4FdIhVHTMWF9nectjvJthk1V2KvTVssBoJ+nTcYUoOvR61x22TarhcmkLKo3aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kVuzc07g; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CQOth9ySaBABRliRVaE/238sOcRC6KpPU8wdz27EqpM=; b=kVuzc07gkySR3GhLgFckeWGNZN
	tlb/U3BWQAJUld6FcXQdHf+nL711yuXoGpTjdSu/t5qcOey5ukpFeCS+SZylTwOSHiR6cgY3QJlNH
	0lM+xhy2HDNYyxmt78xFskZdmhhCUYOwzs3h8Rmz96SOmMLJ8m9+wCQqR9CwdIyq0aZlETTEORCHu
	5RjCNzbhhIfnFdwa0WR32wHKGhcapb2bqbDvstgz+CfUqt0WsSFq+hv21PG0Ept/mWpoFtMRnuINT
	LmqJm10HHU4EwK6o8qkKI3PJ6wOAFp+noHLwyyya6EpRWhH9WOJps794W1bloBkX/ZUShiLJXGEGs
	UkcZV3rw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uJcVU-0000000BgK6-0ED4;
	Mon, 26 May 2025 18:25:04 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 61F56300472; Mon, 26 May 2025 20:25:03 +0200 (CEST)
Date: Mon, 26 May 2025 20:25:03 +0200
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
Message-ID: <20250526182503.GQ24938@noisy.programming.kicks-ass.net>
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

> +#define KLP_RELOC_SEC_PREFIX		".klp.rela."
> +#define KLP_SYM_PREFIX			".klp.sym."

This max symbol length test is getting more and more broken every day
:-)

