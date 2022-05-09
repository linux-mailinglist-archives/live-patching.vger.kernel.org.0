Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3B7520520
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 21:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbiEITVo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240546AbiEITVn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 15:21:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1921C0F32;
        Mon,  9 May 2022 12:17:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB2E96166F;
        Mon,  9 May 2022 19:17:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0534C385B2;
        Mon,  9 May 2022 19:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652123868;
        bh=rrqSz30f8zO7usei05O3p8suFElpLq4mSl05OR/sTlY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tgJYNdPl6zeDpfJg7STc7bqPgPB6QJuhzEfcuHocRr4RaHdC8Kk7+zuLDssdnNzTN
         zjfi6GK/QYoUrbHkHRTsQBzZiBWOOqWIE30TeREc2qCKl1Fd1dFMbKZE8pOdStXpj/
         ixZjNs8Shdh+TrD2leMylUFRPtGWpl4qkUZZaKiK0mSoTB/IfsefjmR75HIfNYiLC3
         k+pRdGrSZBEj79lzXOdc7Ul+FzwV+btTNozLYwQrgEsgiUmMNaxh5b7pdxSfMEfjhx
         6sa90hPNpKOIhdIy3TO4bII+g/Yf53VMEWTCxmWltecj0hRpUkOXL2wapTohFQ33fe
         PFzKal7cc63hw==
Date:   Mon, 9 May 2022 12:17:45 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@surriel.com>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Message-ID: <20220509191745.yk2txsa4cv3ypf6k@treble>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
 <20220509180004.zmvhz65xlncwqrrc@treble>
 <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 09, 2022 at 03:10:16PM -0400, Rik van Riel wrote:
> On Mon, 2022-05-09 at 11:00 -0700, Josh Poimboeuf wrote:
> > On Mon, May 09, 2022 at 11:52:27AM -0400, Rik van Riel wrote:
> > > Does this look like an approach that could work?
> > > 
> > > @@ -315,6 +321,9 @@ static bool klp_try_switch_task(struct
> > > task_struct *task)
> > >         case -EBUSY:    /* klp_check_and_switch_task() */
> > >                 pr_debug("%s: %s:%d is running\n",
> > >                          __func__, task->comm, task->pid);
> > > +               /* Preempt the task from the second KLP switch
> > > attempt. */
> > > +               if (klp_signals_cnt)
> > > +                       stop_one_cpu(task_cpu(task),
> > > kpatch_dummy_fn, NULL);
> > 
> > I must be missing something, how is briefly preempting a kthread
> > supposed to actually transition it?  Won't it likely go back to
> > running
> > on the CPU before the next periodic klp_transition_work_fn() check?
> > 
> That's the kind of feedback I was hoping for ;)
> 
> I looked around the code a little bit, and it seems
> that only the idle tasks can transition to another KLP
> while they are running?

Yes.

> That makes me wonder how the kworker thread that runs
> the klp switching code transitions itself...

See klp_check_and_switch_task(), in addition to checking blocked tasks,
it also checks the current task.

> Should kernel threads that can use a lot of CPU have
> something in their outer loop to transition KLPs,
> just like the idle task does?

Maybe - I suppose this is the first time we've had an issue with
CPU-bound kthreads.  I didn't know that was a thing ;-)

-- 
Josh
