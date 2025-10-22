Return-Path: <live-patching+bounces-1790-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 01780BFC165
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 15:19:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4CE213505D1
	for <lists+live-patching@lfdr.de>; Wed, 22 Oct 2025 13:19:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F22226ED20;
	Wed, 22 Oct 2025 13:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OuvXtMjJ"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07BD26ED36;
	Wed, 22 Oct 2025 13:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761139139; cv=none; b=a80uAoxdUHJxKwB6JO8Crbo6xcVdEaCkvvHy6+LgIvfbsWQ1mvLjhSPznO4HnHsTJJnF7cII2TkvGzuTnY5HByfI8KsPztV9uDuWi/53fgjykysrbBvZlV7CviEW7BLvc4T+jWbfWSHxkVD6iWFv1Muj4+gpiYzUHFxNFvmYxy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761139139; c=relaxed/simple;
	bh=LqZWVjJfglDzrK9P59MVwBlHq/m6Xj8brgtwQrM+Fqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=juVIyPGlqEKjNzAa6DRuBnYBqhT4buzEiOzUZwxZK6Ua0WDe5Yd1Czy/PNdXPZekHc6UnOaqfNRr1uXbmANMTwdIF9y2lnidRuYVMV82ChjU0lEi0Agd32RcnqWtmSBKP6+4BIrtIoZ4C6BJwSSFojZIBv2D2Oud5K6d698JTd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OuvXtMjJ; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=LqZWVjJfglDzrK9P59MVwBlHq/m6Xj8brgtwQrM+Fqs=; b=OuvXtMjJVVFBrEXpN1QjxGWgFW
	XaMtU5twYehQBUY6XfE/qNy0Jy2kHv1eSnorx7LnIGXkhH/TSKSoEX5vJ+MSyl5To0lz4MEBIT8Ab
	89ctoq33OP6F59NtzGR722OxqG7WS6K5gCbZ1H5SHy2AoeGdn6DR13mhXrAg2BJ6hzV2TmgUKMMvD
	wxliY/hFn8NB5p5dlQ2SA7xPwNA7F8IWPeHxlgYhFvg88fUDZUw0WzFV+7DJb65sIdB1r93GobUII
	M5KFKg61LOsreKUPORJTcPx1qYRM3TGWG1O2ABOUuH5HlDBXAAgfmHW7ciOVRUyTOzyPTN0Zq1gzl
	1A3RgtUQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBYjU-0000000683H-0XSI;
	Wed, 22 Oct 2025 13:18:29 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4B99D30039F; Wed, 22 Oct 2025 15:18:28 +0200 (CEST)
Date: Wed, 22 Oct 2025 15:18:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Brown <broonie@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Cosmin Tanislav <demonsingur@gmail.com>
Subject: Re: [PATCH] module: Fix device table module aliases
Message-ID: <20251022131828.GO4067720@noisy.programming.kicks-ass.net>
References: <e52ee3edf32874da645a9e037a7d77c69893a22a.1760982784.git.jpoimboe@kernel.org>
 <13384578-a7e7-439a-8f30-387a2cb92680@sirena.org.uk>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <13384578-a7e7-439a-8f30-387a2cb92680@sirena.org.uk>

On Wed, Oct 22, 2025 at 01:01:40PM +0100, Mark Brown wrote:
> On Mon, Oct 20, 2025 at 10:53:40AM -0700, Josh Poimboeuf wrote:
>=20
> > Commit 6717e8f91db7 ("kbuild: Remove 'kmod_' prefix from
> > __KBUILD_MODNAME") inadvertently broke module alias generation for
> > modules which rely on MODULE_DEVICE_TABLE().
>=20
> It'd be really good to get this fix applied, modules not loading is
> hugely impacting CI coverage for -next - a lot of systems aren't even
> able to get their rootfs due to the drivers for it being built as
> modules.

Oh, this needs to go in tip/objtool/core ? This wasn't immediately
obvious to me.

Let me go queue that then.

