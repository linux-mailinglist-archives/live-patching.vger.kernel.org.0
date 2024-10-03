Return-Path: <live-patching+bounces-712-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D059598F27A
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 17:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B92C1F21ADD
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 15:25:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD3E1A0726;
	Thu,  3 Oct 2024 15:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5fjH8yq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC621E52C;
	Thu,  3 Oct 2024 15:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727969119; cv=none; b=ZMhWPaGP2tYievh1d3azl9zfiJN3sXnfhMNeS1Mf2M6hGs8QDZHfc2+XtNqEBN34J0zD50oSBpWZZgjDQZZl4S2ue/Z3amKrblF5sfV448e1BuTC/wKSSzruPPaFevqG6z7eqZHDVEtBOjV31dzsYhanNvgCVl0ZdhMAZj/8m6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727969119; c=relaxed/simple;
	bh=Pts3p7LO8GWVx3zf0rgkl1j78tk54ufIOFLj+GcUU9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BwicnaYuWdjdoHISspGP9Sc43AmUcAhMHTJNakfpPEnG3SuwZfjTQpv0VJRI/br12tTjWtU3tgJ/vLEkqMXB72C12XRfLJ+QAqRUWpCoZnm+K67iC3OKMxr0xl5ky1uMSnX3+Uh6EawpNcfe4/5WpN2rBmGvmiTfpzssSR61Zmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5fjH8yq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CDCC4CEC5;
	Thu,  3 Oct 2024 15:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727969118;
	bh=Pts3p7LO8GWVx3zf0rgkl1j78tk54ufIOFLj+GcUU9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5fjH8yqGLC0xGsJMUoiUIYuk39wkzeYf2xpRAbKslk3amJGe7F674dhE0crkdShR
	 3EOdl+WhViXgHSao1ozWaLKzHp7PwX2z3QHQaAoVanh4JmG0ZLYF4xvS4RUWoUEt7y
	 lGgZRiX3GC6gKchrMQ5I927LjTAd9nycwCHViwUWFoiSlo3ndDAMPfeK3SGLhJlCVQ
	 ZGutuoO1P6dirAzGYMMsVixT5PA+yQmgLTJFJ2ikl+LKnKqswrqaWLxxI2lLUWGyG0
	 EQMHNoLyfbsWXsEHTAI4yMAXXtuQLv8AVqqHu4dB/cDBBhS8MSgNc0q1PY1el6NLd0
	 J07fu3i1ck7Jw==
Date: Thu, 3 Oct 2024 08:25:16 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
	Jiri Kosina <jikos@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
Message-ID: <20241003152516.fzga2uaivzg57q4s@treble>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <20240929144335.40637-2-zhangwarden@gmail.com>
 <20240930232600.ku2zkttvvkxngdmc@treble>
 <14D5E109-9389-47E7-A3D6-557B85452495@gmail.com>
 <Zv6FjZL1VgiRkyaP@pathway.suse.cz>
 <A7799C9D-52EF-4C9A-9C22-1B98AAAD997A@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A7799C9D-52EF-4C9A-9C22-1B98AAAD997A@gmail.com>

On Thu, Oct 03, 2024 at 10:59:11PM +0800, zhang warden wrote:
> > This attribute specifies the sequence in which live patch modules
> > are applied to the system. If multiple live patches modify the same
> > function, the implementation with the highest stack order is used,
> > unless a transition is currently in progress.
> 
> This description looks good to me. What's the suggestion of 
> other maintainers ?

I like it, though "highest stack order" is still a bit arbitrary, since
the highest stack order is actually the lowest number.

-- 
Josh

