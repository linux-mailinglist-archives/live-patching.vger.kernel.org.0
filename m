Return-Path: <live-patching+bounces-2409-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uGD0EBs/52no5QEAu9opvQ
	(envelope-from <live-patching+bounces-2409-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 11:10:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CAED438A72
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 11:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 357C4301D33D
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 09:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D363A16AB;
	Tue, 21 Apr 2026 09:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xcc1CP1c"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A90539C657
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 09:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776762328; cv=none; b=IBOPPQTYlMxvxy3ddMrTFJSb3JuclrbRA9gUlgEl4Hb9N67nAtuVjC3TMlrhd5Tjcdp1Kd4JJUka9SwRTaxe7txAL3deNtfKdoKZagG/bEgYBwBH8bc1PSKbtAaoWn/EyRoY7U4JbO/MvWvAfeSdISVS+ROXrU8nHwHAPnxpb/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776762328; c=relaxed/simple;
	bh=jNS11TxrGCzC/ayr6dWUKwMQYFcjJbkoMNjsM92foRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ht0B4d+QI1/hHajtWBAA/scuasz2eMPJ8ZhyLNhMfsej9cjxqCpR9D0v5f0ZnVPTDLl91rWqVV1Jh1Vov6Cq76PG0FFYKuyhf0exKsytQ6v8kz8B8BKTnzaNQPL4amX2mxCPoJRcpwI3PwfT6cX6v2YojPfwpkq6wvnCfM8th7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xcc1CP1c; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d75312379so3054058f8f.1
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 02:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776762325; x=1777367125; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=Xcc1CP1cnpjrdwUmB5v0J4Irq7DUhlBQD21ey2Ch8Kf6N2zXz11+vDy6TZgmIaAUJC
         +zoEz8FhqsnU8ZDeplIlW5qDu4M1jS604a2J+/T4WHykYlPpreT7WCgIS73DUOordZhU
         GSQpP79dJgdMCPtm+L0j6TbNe5PuLwUFNi+EpHD1QPWzLgzk5WJ2OJHQfvHv7r2ufHNM
         nX6nSDXwcL1hB+Q6aa5W7/7q/7STQTSZPxNsZMvv51vHikW+kMIXBLc6pQtRVKpk8XIr
         0PPbT4gMMmh5vdD5GsAgJgoWAemXJ+aXAnYSthNEwj6jZRtccCdx87/R/FK10xXMgnxj
         3nYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776762325; x=1777367125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bq9QG9cvLvgk2UCX7BCWel9Xe8wLb+Jo7joT5Pt0764=;
        b=sLCMEGVBABACQlswXYgCOWB68NgkVocrOKKLLPvonbXl0GLGBdZ8kxfChklOvpeGdj
         bRv1yssL0vlBEEGn/Uo4Bta2QRjpSmIA2j1N4kMDxJjL9hMSFK9OfesY8f/Ywf8YeR4M
         G0rl0jc7Mr7cldU7vNY6qn1CeHgoNDyL7jk1KjhmyCZ1bXfXgD9PbwsykszcRalvzw9n
         dy7G1DarklB7+gdx55niIvA6fbkvPN9BSc3fG6cChmMQfkVgsZsKj3oD419YixoYgH06
         xK3LLod3CL00d79MLWyilBia25TrQRrn4UCOte+N3nTykMjxN69+CA1jVBM/NuKPmkwB
         JziQ==
X-Forwarded-Encrypted: i=1; AFNElJ/oxrg8LgEyC29THZrZ/hS1g2sXOFidme62yUALEK8EitRkiCGGKWQbB5crJILM3werkvtF/GQD4Caan+Y/@vger.kernel.org
X-Gm-Message-State: AOJu0YxK0TVujjyjeXobUdVudz4/coBJKUJo6vFCjA/CwgcNK3+mupth
	FukcnsUd4J1s0mWF/+inNNOZjF2nE809hDRwnnVzvLbTTACkq4N3sPOXBIBL07MLCRo=
X-Gm-Gg: AeBDiesqLDHhB+8Eg3DNvLn9XmG5aBtgzH5XkRGgl9KghrtHxhbXEkZbhVf5Nb9BCAD
	6EfhEahbLcAEM9ENyQ6cXPyTslHHgd7Ffrvz+xIMgjUplRMbiOc+7UjB9/ROXbrrcjkJ4zEjztz
	pMjJ2fVUtiAVfQCjeu2e8iv7JZzQgQLLUvbbr4ui27eW5xlCvcjQT7wQ+L4L9rp7dHXQjgZNALT
	OezYrF7/aTXQZ843Rp9Z7Mi6wYTqhNrFMXwb+imy2P+4hc7efRIn3bIYg8v4C/vJHGM++zA0QfI
	9JR9CbkHzPIoF8H8Kq7gpps4Uk++lLB7ajd8loY/P0pkAAVAa+sqSL586Mb5LPQVZv6y2ZyG+UB
	Ci5cGrHTYmmHLNjTZGA8VEkf+uVjm+AqhUVJJHIr7DWIYXWI/3gbcp3aSSmBKK6ZjMuOi5fyKby
	3c4uTUAg7S2aIGDTV2fAxygi1xsqIBHX+vmkj9hF8QsGEVr0ByRXc=
X-Received: by 2002:a5d:5c81:0:b0:43d:729e:f23a with SMTP id ffacd0b85a97d-43fe408dab9mr19081632f8f.22.1776762324596;
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Received: from pathway.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm39945351f8f.6.2026.04.21.02.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 02:05:24 -0700 (PDT)
Date: Tue, 21 Apr 2026 11:05:21 +0200
From: Petr Mladek <pmladek@suse.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
Cc: chensong_2000@189.cn, rafael@kernel.org, lenb@kernel.org,
	mturquette@baylibre.com, sboyd@kernel.org, viresh.kumar@linaro.org,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	bmarzins@redhat.com, song@kernel.org, yukuai@fnnas.com,
	linan122@huawei.com, jason.wessel@windriver.com, danielt@kernel.org,
	dianders@chromium.org, horms@kernel.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	paulmck@kernel.org, frederic@kernel.org, mcgrof@kernel.org,
	petr.pavlu@suse.com, da.gomez@kernel.org, samitolvanen@google.com,
	atomlin@atomlin.com, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, rostedt@goodmis.org,
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	live-patching@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] kernel/notifier: replace single-linked list with
 double-linked list for reverse traversal
Message-ID: <aec90caYZDHDAHgw@pathway.suse.cz>
References: <20260415070137.17860-1-chensong_2000@189.cn>
 <20260420144429.57b45f2beece690bceea96ec@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420144429.57b45f2beece690bceea96ec@kernel.org>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2409-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[189.cn,kernel.org,baylibre.com,linaro.org,redhat.com,fnnas.com,huawei.com,windriver.com,chromium.org,davemloft.net,google.com,suse.com,atomlin.com,suse.cz,goodmis.org,arm.com,efficios.com,vger.kernel.org,lists.linux.dev,lists.sourceforge.net];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[47];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[189.cn:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pathway.suse.cz:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 8CAED438A72
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon 2026-04-20 14:44:29, Masami Hiramatsu wrote:
> Hi Song,
> 
> On Wed, 15 Apr 2026 15:01:37 +0800
> chensong_2000@189.cn wrote:
> 
> > From: Song Chen <chensong_2000@189.cn>
> > 
> > The current notifier chain implementation uses a single-linked list
> > (struct notifier_block *next), which only supports forward traversal
> > in priority order. This makes it difficult to handle cleanup/teardown
> > scenarios that require notifiers to be called in reverse priority order.
> 
> What about introducing a new notification callback API that allows you
> to describe dependencies between callback functions?
> 
> For example, when registering a callback, you could register a string
> as an ID and specify whether to call it before or after that ID,
> or you could register a comparison function that is called when adding
> to a list. (I prefer @name and @depends fields so that it can be easily
> maintained.)

This looks too complex. It would make sense only
when this API has more users.

Also this won't be enough for the ftrace/livepatch callbacks.
They need to be ordered against against each other. But they
also need to be called before/after all other callbacks.
For example, when the module is loaded:

   + 1st frace
   + 2nd livepatch
   + then other notifiers

See the commit c1bf08ac26e92122 ("ftrace: Be first to run code
modification on modules").

> This would allow for better dependency building when adding to the list.
 
> > 
> > A concrete example is the ordering dependency between ftrace and
> > livepatch during module load/unload. see the detail here [1].
> 
> If this only concerns notification callback issues with the ftrace
> and livepatch modules, it's far more robust to simply call the
> necessary processing directly when the modules load and unload,
> rather than registering notification callbacks externally.
> 
> There are fprobe, kprobe and its trace-events, all of them are using
> ftrace as its fundation layer. In this case, I always needs to
> consider callback order when a module is unloaded.
> 
> If ftrace is working as a part of module callbacks, it will conflict
> with fprobe/kprobe module callback. Of course we can reorder it with
> modifying its priority. But this is ugly, because when we introduce
> a new other feature which depends on another layer, we need to
> reorder the callback's priority number on the list.
> 
> Based on the above, I don't think this can be resolved simply by
> changing the list of notification callbacks to a bidirectional list.

I agree. I would keep it as is (hardcoded).

Best Regards,
Petr

