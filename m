Return-Path: <live-patching+bounces-1489-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5359ACF935
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 23:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3D2F16D822
	for <lists+live-patching@lfdr.de>; Thu,  5 Jun 2025 21:18:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64C5E27AC59;
	Thu,  5 Jun 2025 21:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utVVSJ8q"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5AA1E7C03;
	Thu,  5 Jun 2025 21:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749158277; cv=none; b=QD56pDv09O7VVh/3iQMCSX+CxFPCzFcmmNWu6Sf8MfAOMp1xSk9TyO3yi51j39LS6Oo9uM5gWdNBx4P2CWa4hrvJC/GaKq7DfrtGzf07rI6Znq4di7RbITeclo0wK8/j52g80AuVsCnZCRdz4XtQirCcgPCsjerCPyPU+vUJGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749158277; c=relaxed/simple;
	bh=Rx92ICINiPpXEFMv48XBXvX7sM/iWVaB+839wowuIEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HA3SU8CuHd00CXplvjuFOyJ5Sk1RGQD/y/QR6Q0dyvgVmXzh6VOkMUezI74b5oQfLaUkLxWwHwOLqCCWX68uWvsxxGdhaaJQw/Tcvzn/rjJaNKuDOy6T1mhDKhyT0g/yOVHXH/7Of2VZIV6o4j7Y8nRlronZiRvSgBS7yRmVJdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utVVSJ8q; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E93C4CEE7;
	Thu,  5 Jun 2025 21:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749158276;
	bh=Rx92ICINiPpXEFMv48XBXvX7sM/iWVaB+839wowuIEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=utVVSJ8qclGg0/ejQ95mVqJhepCJoh6iSdQT42wx3U69R25CaW4PnePlmAzh8v5UJ
	 gbfShXC2aMQnKm9tfc3MKYgN0CmHv1GAZfKabUUJsJ/lZ63XodKo9Fud0ZPebN/lYX
	 oCkiZYQcapdxH1E4fVyWJzIFfTKQW+C/dZxFL7D3nYfbC19SVnFlp1QuNmEiZRJ5iO
	 WesKoAf+YD2/Hjq6m8+w0nEw76DFa2OKxyz390GOK9MVb7s8s/k+yazkrm2eteP3cI
	 yPT1NsqQkqnqi4CdlRtC+sRNRMKCbUF9rGVQ1vJe+fEJC06D33IH40+VUaiOVd2HEb
	 OokJBJ9DliGfQ==
Date: Thu, 5 Jun 2025 14:17:53 -0700
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
Message-ID: <rskhvbqhlgif7gkm7ajtznd4c3xl7esxnqkppikpijkbjrlfyp@2vkkwm2v5xop>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <20250526185040.GT24938@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250526185040.GT24938@noisy.programming.kicks-ass.net>

On Mon, May 26, 2025 at 08:50:40PM +0200, Peter Zijlstra wrote:
> 
> Let me hand you a fresh bucket of curlies, you must've run out :-)

Thanks for the freebies, imported curlies aren't so cheap these days!

-- 
Josh

