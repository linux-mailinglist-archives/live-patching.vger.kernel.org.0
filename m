Return-Path: <live-patching+bounces-570-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E4E96970B
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 10:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21F5E1C23A5F
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 08:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A800E201252;
	Tue,  3 Sep 2024 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qrnZsW65"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB511A3AB6;
	Tue,  3 Sep 2024 08:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352155; cv=none; b=kRjY6gJh/n6KGVF1J1Sjc4YFswIiVQEsyzmg+4j9+5Jmc0am40QRh7aG3FN/J/x31hbt0pwav9xusIwxl7C2GPGZ3qAVlrKfmOS0FiWDoJN/s1K7BMMTjedFKr3aOpXukS0dfffxt+6SjNyFLRYhbQjA23XfdrwytH9e79xojFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352155; c=relaxed/simple;
	bh=XHThfvecMWnHVoWyhx5fVWBfkn6uUcz5Hr+0eH7kgBM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JKpl7ZUWRM0JhRrLsDdlLHo4ou20rHunTE65ALaeh0lpBxjQu2wsoX6wWzaR+t5sq/VVu/djL+2DLABjHWAlBUpHK0/vCugT34aqd/jTAp7Z5n/D/+NgpfRxc2/+fAKuRp4MCwAx+zpXhOHQvzCkRm/VbQQ6MEO1qBTNWBEnvn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qrnZsW65; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F5AQp6KPXCrFsNoLD7654I5rCWGg696HbTeNZbZmNsU=; b=qrnZsW65/tYG6VCIqazNZ3PbAt
	v6S+DJ0JERSprLI8e0aNjqtdEwa8SX9CFX69acmEWd3M+KnzTm8yPpdhDudtPCACxQoUcBOvSQyA4
	q3bcASZSPPlVU7iIevc6XSliph5fExMC/rC+o7hcNNkLwWaJpgzjCkyUxykhC6wI23Ss6kqS2vt79
	PmM+LtA7dH9PD0DFHRhBJLpFGWVXB1ImS7CSrWzS3EkPQg3iJ/yeZnPyvTt5yrHGquzqie1CiCjgW
	yNXg/HPfxdXZw/0NqtBmVL4i22ceFcECOgkmkZPODwHVIl7ZnUVuSt8c5gsUaiOF4reFBv8I4baCn
	yOryRM9Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slOuU-0000000CHzH-22ka;
	Tue, 03 Sep 2024 08:29:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B869A300390; Tue,  3 Sep 2024 10:29:09 +0200 (CEST)
Date: Tue, 3 Sep 2024 10:29:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 28/31] x86/alternative: Create symbols for special section
 entries
Message-ID: <20240903082909.GP4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc1bcb1cd875350948f43c77c9895173bd22012.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 09:00:11PM -0700, Josh Poimboeuf wrote:
> Create a symbol for each special section entry.  This helps objtool
> extract needed entries.

A little more explanation would be nice,..

