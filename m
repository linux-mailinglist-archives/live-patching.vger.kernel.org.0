Return-Path: <live-patching+bounces-1604-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96BA8AEBD97
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 18:36:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 486D4162D50
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 16:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 828C6213245;
	Fri, 27 Jun 2025 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTRYrLo0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594D61C1741;
	Fri, 27 Jun 2025 16:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751042172; cv=none; b=MtuUcFmghfqIR4muha+xSo6BXnP5UxvDqPafh2RkQSipNBNotHbExYShFJCjvDAqZ1jFAFUPoyuiSD3HFmUYFBMo7srG4kYPDDUwqAZ1thB9zmXJOG8QDwsyfDW0yxkGgjf3Esck2bKPMqejwRUU3SA+edBkCzToNSvrIDpJebw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751042172; c=relaxed/simple;
	bh=68erTh6FWYp/Sj54YCsq7ymlLRmTSgRaYhiJuroh+xA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSK1eEbrueK44jgps9tUpOYvvKZdJxXz537N3+N+27C3GzWz/Ffx2dIyrRtcqbnVVbRu96N6xe+QTXy+nn8U8Yh4QhFAdJM6ECim8bZZj8dIk4HBP38llHw3bmsNF+2PfzB/DHBN1c1375vO2Fb39mQBbVHVwevWkZmQZHtBibA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTRYrLo0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91061C4CEE3;
	Fri, 27 Jun 2025 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751042171;
	bh=68erTh6FWYp/Sj54YCsq7ymlLRmTSgRaYhiJuroh+xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTRYrLo0Nuyp3YIjRN05J/HL5a4ynKCIBFjd0nZ8N1cQQQDpJacV3NE4KfiDqDjzv
	 MCHPv/6U2aaKy7UMP/TciS/Y2zHiUaOMmRPKM6XSIcNvKnp+g2K4G0TBFrevHtc7h3
	 Idye/C3v/WLupL/ODUAYrAd2KsWc6g1KVrQHjCQUTtxo6bWSNjcLg8HOw2z70nGclp
	 +l6F39LEGPNoXIWvdgpCXSSlv6ZuYtoFMtd66cBdm1sup6dfKzTVUUrfrLA02KbeE8
	 l1j+4ip9QyfgCirD9ax4YmWHH+4mf/O/e3Ecm8QqF23mvm5F+bPahusrJWJ18JhMXh
	 F5NqTuq2mS8yQ==
Date: Fri, 27 Jun 2025 09:36:08 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch <dylanbhatch@google.com>
Subject: Re: [PATCH v3 26/64] objtool: Add section/symbol type helpers
Message-ID: <arotzpll7djck5kivv3d4bz2jpkitpejkppaaevoqk5hqddr57@aunxxyjwnrxz>
References: <cover.1750980516.git.jpoimboe@kernel.org>
 <c897dc0a55a84f9992b8c766214ff38b0f597583.1750980517.git.jpoimboe@kernel.org>
 <20250627102930.GU1613200@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250627102930.GU1613200@noisy.programming.kicks-ass.net>

On Fri, Jun 27, 2025 at 12:29:30PM +0200, Peter Zijlstra wrote:
> Naming seems inconsistent, there are:
>
>   sym_has_sec(), sec_changed() and sec_size()
>
> which have the object first, but then most new ones are:
> 
>   is_foo_sym() and is_foo_sec()
> 
> which have the object last.

For the "is_()" variants, I read them as:

  "is a(n) <adjective> <noun>"

e.g.:

  is_undef_sym(): "is an UNDEF symbol"
  is_file_sym():  "is a FILE symbol"
  is_string_sec() "is a STRING section"

Nerding out on English for a second, many of those adjectives can be
read as noun adjuncts, e.g. "chicken soup", where a noun functions as an
adjective.

If we changed those to:

  "is <noun> <adjective>?"

or

  "is <noun> a <noun>?"

then it doesn't always read correctly:

  is_sym_file():   "is symbol a file?"
  is_sec_string(): "is section a string?"

-- 
Josh

