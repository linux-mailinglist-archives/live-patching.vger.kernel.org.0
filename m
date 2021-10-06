Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBAB423A25
	for <lists+live-patching@lfdr.de>; Wed,  6 Oct 2021 11:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbhJFJBz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 6 Oct 2021 05:01:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47356 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbhJFJBv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 6 Oct 2021 05:01:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 29B7320345;
        Wed,  6 Oct 2021 08:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1633510799; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eKqMImRNd0c3k50j3g01wRgNX9Ro+v9p2fDSwGsbLWk=;
        b=ycSY7PllWcAZH5HUjpCQ/mnzsotzRcdf2xhSaBStYkQTsp3fOEZQLii3vhiEPPWIqYb/ez
        zb89U/vaMecCmIRNYdvLMM46Nlh7b97SRVaL+IQ8VUbR4pOAuDKTYonEZ0LU1JNGnBFFDE
        YOrLAtrmphkzPZPlxH1rbxhck4Q+ZCg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1633510799;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eKqMImRNd0c3k50j3g01wRgNX9Ro+v9p2fDSwGsbLWk=;
        b=7pa+pdfXc0TEWsqKiHvtgRldreVZaRlAZv7WEOTM2J3lxPOwUpuQja4evxxfBwmvcYWniF
        mgvXF8iJZkvcWEDw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DCCB9A3B84;
        Wed,  6 Oct 2021 08:59:58 +0000 (UTC)
Date:   Wed, 6 Oct 2021 10:59:58 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        pmladek@suse.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 03/11] sched,livepatch: Use task_call_func()
In-Reply-To: <20210929152428.709906138@infradead.org>
Message-ID: <alpine.LSU.2.21.2110061058470.2311@pobox.suse.cz>
References: <20210929151723.162004989@infradead.org> <20210929152428.709906138@infradead.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 Sep 2021, Peter Zijlstra wrote:

> Instead of frobbing around with scheduler internals, use the shiny new
> task_call_func() interface.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>

This looks really nice. With the added check for "task != current" 
that Petr pointed out

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
