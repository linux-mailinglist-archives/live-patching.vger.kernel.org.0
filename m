Return-Path: <live-patching+bounces-1317-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047A6A6BB95
	for <lists+live-patching@lfdr.de>; Fri, 21 Mar 2025 14:16:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7544716E46D
	for <lists+live-patching@lfdr.de>; Fri, 21 Mar 2025 13:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E721F03C9;
	Fri, 21 Mar 2025 13:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ha56DOvk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NOkMXnfA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="Ha56DOvk";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="NOkMXnfA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA6F1CAA81
	for <live-patching@vger.kernel.org>; Fri, 21 Mar 2025 13:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742563004; cv=none; b=JrwaV8y3vtx1LQIpOzsR1s0o2AXm4wPUvgvuVDwqmqjZWko1MJ3HxVee00nTULbVquq8570c/Nbo2ChNMOXssFVfeknRT3IvIvPnzKrpun2JvkGlglqb2d8bLuWd31Ghv2oJQkQokfZoRNXOZFwUG+EdBvjfvWMb7eGsy/SGyKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742563004; c=relaxed/simple;
	bh=8PwEC2vt6dknv9qyvyQOYEXGogNv4J4YQejuN+xo7vs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AxJMOuAVaasz81U6+gvKdg4Gl8puSZdks1+dUQdWfb07FtIWn/gwVAYIyV/9Wcb8TlIT5w+KqX9srnFYID0k81MRa2pgLuj0ldHt4dXtN0UvPiXn+XiVhakNnR06A5oJkRV6sVWRYF+p1OCEF47olt4lcV6CFyvDEeCD4Rhqlgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ha56DOvk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NOkMXnfA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=Ha56DOvk; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=NOkMXnfA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7263E21B18;
	Fri, 21 Mar 2025 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742563001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2sEoiUD47B+5R55uHJLU/3iWVb3rNc9jLigat8IjVVc=;
	b=Ha56DOvknKwKT0i4bEYIEajhiqmHSWM05qnqt+z+nveCD9JwGsNdRFC6z8Y/tb61kfolQW
	W9KVyr4XRjpzciBqN8yCaESU6V56YXqCfCbTA/W9ZvIK16MSN2cgCvZhCSaKxtgjtNAcV2
	D0Bz4vkCKf0y0rYBkfGdpNBLO1+RYO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742563001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2sEoiUD47B+5R55uHJLU/3iWVb3rNc9jLigat8IjVVc=;
	b=NOkMXnfAgXWZaLc/Gwd7Gp33aHfWIkxt6NqEu0ufqMv7xn+lasvJo/nhjSb3RTCPEY8oXU
	lnCmcRfJfABq6LAA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1742563001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2sEoiUD47B+5R55uHJLU/3iWVb3rNc9jLigat8IjVVc=;
	b=Ha56DOvknKwKT0i4bEYIEajhiqmHSWM05qnqt+z+nveCD9JwGsNdRFC6z8Y/tb61kfolQW
	W9KVyr4XRjpzciBqN8yCaESU6V56YXqCfCbTA/W9ZvIK16MSN2cgCvZhCSaKxtgjtNAcV2
	D0Bz4vkCKf0y0rYBkfGdpNBLO1+RYO8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1742563001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2sEoiUD47B+5R55uHJLU/3iWVb3rNc9jLigat8IjVVc=;
	b=NOkMXnfAgXWZaLc/Gwd7Gp33aHfWIkxt6NqEu0ufqMv7xn+lasvJo/nhjSb3RTCPEY8oXU
	lnCmcRfJfABq6LAA==
Date: Fri, 21 Mar 2025 14:16:41 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Song Liu <song@kernel.org>
cc: live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
    jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org, 
    pmladek@suse.com
Subject: Re: [PATCH v2] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
In-Reply-To: <20250318181518.1055532-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2503211416220.29639@pobox.suse.cz>
References: <20250318181518.1055532-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On Tue, 18 Mar 2025, Song Liu wrote:

> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
> when CONFIG_KPROBES_ON_FTRACE is not set. Since some kernel may not have
> /proc/config.gz, grep for kprobe_ftrace_ops from /proc/kallsyms to check
> whether CONFIG_KPROBES_ON_FTRACE is enabled.
> 
> Signed-off-by: Song Liu <song@kernel.org>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M

