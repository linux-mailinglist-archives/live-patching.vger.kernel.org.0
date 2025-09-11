Return-Path: <live-patching+bounces-1641-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5946BB5343A
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 15:46:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1C9D17BE59B
	for <lists+live-patching@lfdr.de>; Thu, 11 Sep 2025 13:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46B8332F770;
	Thu, 11 Sep 2025 13:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EozyvaEr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FbeBX9Ci";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="EozyvaEr";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="FbeBX9Ci"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66E73148A3
	for <live-patching@vger.kernel.org>; Thu, 11 Sep 2025 13:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757598298; cv=none; b=B23lsp8bRDmF3Uqi41GSrg1O3cUMQoYIJGUiWZwSZu4e4gqksHkzFD4yOddKR1woVGgemJTVLil1wBcDCoa8bXiJjtw19QWw2eyKdT4BzGTgTL44qYIKVAwSXfbpO2Jps2vu3jXQpCP5IpuIqmFvWUmsYr4e1B5KV+3CNXhgUyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757598298; c=relaxed/simple;
	bh=if0wyhsg28GBdlEVZRv/pMlX+s4OiC6AA8xUZJROLz4=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=VALR5WnsFAH8R21Mq2ZH6ll7aKUTyGSpMq7zNPxLEpE9fc9KVwcNv3GnyF1OpF4x7kqHOJZjb/RRXe9Ent658Yjq9w3yb2AlKGVI+BbmXhD8xTzsoj8vbGyci0Bjtq/C0afj+jTuXwGqqL6mQegua+nhX9L5V9Acp+xapPWOxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EozyvaEr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FbeBX9Ci; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=EozyvaEr; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=FbeBX9Ci; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8A5633F264;
	Thu, 11 Sep 2025 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757598293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ASPlsD6t+2c3t/wmrkPwFCg5dKtGWCO1E7eb28YsE0=;
	b=EozyvaErdyy768U64P6RhuMBGhCxlfI5PlKXR2q3WGTotaNZpFzlXbFeid0jgx4sdVbFfM
	scHvJcXzH+AM/LR1dWHHk3AVdqO8/APyRFIJLufeaoXXxW/TUcFCo5JiPn7OdOPqGjKbHP
	AzAy3qOOwgGrs1SSNVESRivAuaJBcfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757598293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ASPlsD6t+2c3t/wmrkPwFCg5dKtGWCO1E7eb28YsE0=;
	b=FbeBX9CimiS3m49Qrx8IZgE+OU+O/Gj/hfLErHi/cMTnzbpUEzBv93xm3kO+mUBFsCPGR+
	LFQrKNkjggHTQ8DA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757598293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ASPlsD6t+2c3t/wmrkPwFCg5dKtGWCO1E7eb28YsE0=;
	b=EozyvaErdyy768U64P6RhuMBGhCxlfI5PlKXR2q3WGTotaNZpFzlXbFeid0jgx4sdVbFfM
	scHvJcXzH+AM/LR1dWHHk3AVdqO8/APyRFIJLufeaoXXxW/TUcFCo5JiPn7OdOPqGjKbHP
	AzAy3qOOwgGrs1SSNVESRivAuaJBcfc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757598293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ASPlsD6t+2c3t/wmrkPwFCg5dKtGWCO1E7eb28YsE0=;
	b=FbeBX9CimiS3m49Qrx8IZgE+OU+O/Gj/hfLErHi/cMTnzbpUEzBv93xm3kO+mUBFsCPGR+
	LFQrKNkjggHTQ8DA==
Date: Thu, 11 Sep 2025 15:44:53 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
    Xi Zhang <zhangxi@kylinos.cn>, live-patching@vger.kernel.org, 
    loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] LoongArch: Return 0 for user tasks in
 arch_stack_walk_reliable()
In-Reply-To: <20250909113106.22992-3-yangtiezhu@loongson.cn>
Message-ID: <alpine.LSU.2.21.2509111541590.29971@pobox.suse.cz>
References: <20250909113106.22992-1-yangtiezhu@loongson.cn> <20250909113106.22992-3-yangtiezhu@loongson.cn>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Level: 
X-Spamd-Result: default: False [-4.29 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.19)[-0.955];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_ZERO(0.00)[0];
	FROM_EQ_ENVFROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.29

Hi,

On Tue, 9 Sep 2025, Tiezhu Yang wrote:

> When testing the kernel live patching with "modprobe livepatch-sample",
> there is a timeout over 15 seconds from "starting patching transition"
> to "patching complete", dmesg shows "unreliable stack" for user tasks
> in debug mode. When executing "rmmod livepatch-sample", there exists
> the similar issue.
> 
> Like x86, arch_stack_walk_reliable() should return 0 for user tasks.
> It is necessary to set regs->csr_prmd as task->thread.csr_prmd first,
> then use user_mode() to check whether the task is in userspace.

it is a nice optimization for sure, but "unreliable stack" messages point 
to a fact that the unwinding of these tasks is probably suboptimal and 
could be improved, no?

It would also be nice to include these messages (not for all tasks) to the 
commit message.

Regards
Miroslav

