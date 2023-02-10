Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460EA6928F2
	for <lists+live-patching@lfdr.de>; Fri, 10 Feb 2023 22:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbjBJVIh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Feb 2023 16:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbjBJVId (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Feb 2023 16:08:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21917D3DF;
        Fri, 10 Feb 2023 13:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B46BB825D9;
        Fri, 10 Feb 2023 21:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FF7C433D2;
        Fri, 10 Feb 2023 21:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676063308;
        bh=s+9eFHJUHFSNfVyDHdkS7EW8AqN5IG6JEqbP5VMa2Vg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q0RHGSJrktXjXeV05/ntFECUSTZB5fxapaRrq+KT1/mLcPGaYYS2+lHq/hTE/c+XL
         bb6XiPU4eZZXvqFRjLVv9uJytfRBMVAMQaQPJm4ab3a/hL1aD8nBl6Nv0aHtMqC1JD
         VVeZLANZTiHUe5q4W1q6mU397ARyYTxgUm6auLU3iKbKu5sRz+Uin3lEPe/o3GkQgF
         k7eNiFY0hc40385qL10+1Dn6imafYsNUt5WpxHC9MGbXMbMpb66TcIY6qny0QKoBHE
         PQsbw3sW3Cdj5Tk+OOCQP8WSxXbKx4i9lo0HyMyExe3BOVTz6YSzRmsyka3fm8SIF3
         gIbuXWeXqY3cA==
Date:   Fri, 10 Feb 2023 15:08:26 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <Y+aySl/FCUebuGNt@do-x1extreme>
References: <cover.1675969869.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1675969869.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 09, 2023 at 11:17:46AM -0800, Josh Poimboeuf wrote:
> Fix patching stalls caused by busy kthreads.
> 
> Josh Poimboeuf (3):
>   livepatch: Skip task_call_func() for current task
>   livepatch,sched: Add livepatch task switching to cond_resched()
>   vhost: Fix livepatch timeouts in vhost_worker()

This is working perfectly in my testing. The busy vhost threads get
switched immediately. Thanks for working up these patches!

Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>

Thanks,
Seth
