Return-Path: <live-patching+bounces-576-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C18B496AF94
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 05:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 59DDE1F2422D
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 03:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5051757C8D;
	Wed,  4 Sep 2024 03:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tF2S/Utd"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E2133D5;
	Wed,  4 Sep 2024 03:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422116; cv=none; b=WMmsf0H85/jZB6pJ8+Bc1CEgLKTtxCmuXmx6A05rTQ+6dFqWbSUGtH3u73oYa7e15GT10SgVSQaCN/3VLsKxgBbpxXNOTcfnJ69E3jwB5/ssklAY4GHun0IxIO4zXTvNijKQ7UQ4tjlrDyBmaofeh8aoov/eMH5W1QtJO4dZbVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422116; c=relaxed/simple;
	bh=DssF/4uqjfbKPUshyTRRC9EWX7NBO2tP4IqNZva2w8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+kYqxFtlKkirCeWQaVxuqmUMpVq+hCXNDDrNcWlMWOvDcMN8LG5zgVs+10LUGyKlVLky9eJC64KNdbayjO7Qg49YUezv23AUU8LYC4WIuraw7tX/YAd1iJeLJW4ny8L+A8YX8wvv+b/8lMWhDhqoFBG/Mi6KA/ic+T+H0wF/Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tF2S/Utd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DD8C4CEC2;
	Wed,  4 Sep 2024 03:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725422115;
	bh=DssF/4uqjfbKPUshyTRRC9EWX7NBO2tP4IqNZva2w8A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tF2S/UtdRcrngtknDuhhNrsCrAxOrRu6NpvhAnz/e9xDg7xz1bzaZBroZuEeI/S3Z
	 TYWrUWBp4aZwm6CWgyZC+d9vMI5AOqDQlV4yze7dXHtP3O69pcztfZ+wlNJTn3et3J
	 eXtO3vcw/0FkTE9Y7f+e7Cg1VaivkAA1G7Hmrf1CMgsA6siYrRnPmkLsBw+G+Qu6Xk
	 xxhTWJGNcmaBb0dRZIASpamu3gqWTfG+KqsjiPgRKxeT5hbxlXhXs9Up5byncwSN0P
	 Ty0Ey7tVphwwjqNKBxHTFksPfWpXtQmiP3e/sHzVwop7Qqc8/t82TnKnAzZWAsvqdQ
	 P5ULoC05Xd3jw==
Date: Tue, 3 Sep 2024 20:55:13 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 27/31] objtool: Fix weak symbol detection
Message-ID: <20240904035513.cnbkivqibdklzpw2@treble>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <bcedaf8559e7e276e4d9ba511dab038ed70ebd6c.1725334260.git.jpoimboe@kernel.org>
 <20240903082645.GO4723@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240903082645.GO4723@noisy.programming.kicks-ass.net>

On Tue, Sep 03, 2024 at 10:26:45AM +0200, Peter Zijlstra wrote:
> On Mon, Sep 02, 2024 at 09:00:10PM -0700, Josh Poimboeuf wrote:
> > @@ -433,9 +433,13 @@ static void elf_add_symbol(struct elf *elf, struct symbol *sym)
> >  	/*
> >  	 * Don't store empty STT_NOTYPE symbols in the rbtree.  They
> >  	 * can exist within a function, confusing the sorting.
> > +	 *
> > +	 * TODO: is this still true?
> 
> a2e38dffcd93 ("objtool: Don't add empty symbols to the rbtree")
> 
> I don't think that changed.

But see two patches back where I fixed a bug in the insertion of
zero-length symbols.

I was thinking that might actually be the root cause of the above
commit.

-- 
Josh

