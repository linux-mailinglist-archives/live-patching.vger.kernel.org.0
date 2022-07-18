Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58711578385
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 15:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiGRNTe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 09:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbiGRNTc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 09:19:32 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711336272;
        Mon, 18 Jul 2022 06:19:31 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 1FD4933CC5;
        Mon, 18 Jul 2022 13:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1658150370; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uHzot1g1ilmbChTYESLhhB1Zrae8HwVQwzEp3wCsJXk=;
        b=lnWOEk4se/IsyvUweRMvgKaR/pQWqalfvf85pRJ0DNQDGIAU46+O+9xhKwWiTXMpld3fS8
        7LFPdd5K/x/7b8873r4rqObj2+dt2NhcwWTlMSQoDtvjaX7uWEBFhyuG7EtK+n+2wb9kRn
        M6GqPr5vVg2U6boAvslw0dxBWlXoLvY=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 265362C142;
        Mon, 18 Jul 2022 13:19:29 +0000 (UTC)
Date:   Mon, 18 Jul 2022 15:19:28 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     kernel test robot <lkp@intel.com>
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kbuild-all@lists.01.org, daniel@iogearbox.net, kernel-team@fb.com,
        jolsa@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops on
 the same function
Message-ID: <YtVd4FKOcEmGfubm@alley>
References: <20220718055449.3960512-3-song@kernel.org>
 <202207181552.VuKfz9zg-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202207181552.VuKfz9zg-lkp@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-07-18 15:42:25, kernel test robot wrote:
> Hi Song,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on bpf-next/master]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
> config: x86_64-randconfig-a004 (https://download.01.org/0day-ci/archive/20220718/202207181552.VuKfz9zg-lkp@intel.com/config)
> compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
> reproduce (this is a W=1 build):
>         # https://github.com/intel-lab-lkp/linux/commit/9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
>         git remote add linux-review https://github.com/intel-lab-lkp/linux
>         git fetch --no-tags linux-review Song-Liu/ftrace-host-klp-and-bpf-trampoline-together/20220718-135652
>         git checkout 9ef1ec8cb818d8ca70887c8c123f2d579384a6c6
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash kernel/trace/
> 
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):
> 
>    kernel/trace/ftrace.c: In function 'register_ftrace_function':
> >> kernel/trace/ftrace.c:8197:14: warning: variable 'direct_mutex_locked' set but not used [-Wunused-but-set-variable]
>     8197 |         bool direct_mutex_locked = false;
>          |              ^~~~~~~~~~~~~~~~~~~
> 
> 
> vim +/direct_mutex_locked +8197 kernel/trace/ftrace.c
> 
>   8182	
>   8183	/**
>   8184	 * register_ftrace_function - register a function for profiling
>   8185	 * @ops:	ops structure that holds the function for profiling.
>   8186	 *
>   8187	 * Register a function to be called by all functions in the
>   8188	 * kernel.
>   8189	 *
>   8190	 * Note: @ops->func and all the functions it calls must be labeled
>   8191	 *       with "notrace", otherwise it will go into a
>   8192	 *       recursive loop.
>   8193	 */
>   8194	int register_ftrace_function(struct ftrace_ops *ops)
>   8195		__releases(&direct_mutex)
>   8196	{
> > 8197		bool direct_mutex_locked = false;
>   8198		int ret;
>   8199	
>   8200		ftrace_ops_init(ops);
>   8201	
>   8202		ret = prepare_direct_functions_for_ipmodify(ops);
>   8203		if (ret < 0)
>   8204			return ret;
>   8205		else if (ret == 1)
>   8206			direct_mutex_locked = true;

Honestly, this is another horrible trick. Would it be possible to
call prepare_direct_functions_for_ipmodify() with direct_mutex
already taken?

I mean something like:

	mutex_lock(&direct_mutex);

	ret = prepare_direct_functions_for_ipmodify(ops);
	if (ret)
		goto out:

	mutex_lock(&ftrace_lock);
	ret = ftrace_startup(ops, 0);
	mutex_unlock(&ftrace_lock);

out:
	mutex_unlock(&direct_mutex);
	return ret;


>   8208		mutex_lock(&ftrace_lock);
>   8209	
>   8210		ret = ftrace_startup(ops, 0);
>   8211	
>   8212		mutex_unlock(&ftrace_lock);
>   8213	

Would be possible to handle tr->mutex the same way to avoid
the trylock? I mean to take it in advance before direct_mutex?

Best Regards,
Petr
