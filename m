Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C03A522443
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 20:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349037AbiEJSm3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 14:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbiEJSmS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 14:42:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2DF268669;
        Tue, 10 May 2022 11:42:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81C74B81F8E;
        Tue, 10 May 2022 18:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C043CC385C2;
        Tue, 10 May 2022 18:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652208135;
        bh=v9assGn8KJvRcYSGGwT4yY/3QErO+MifFnTskNJEOJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DOiuH0NVr/M/+D5cGKtA0J1jPwNc7Q8iGoTIHw/Md93ZJ9xbOK2Ywccrswpf+c1dl
         eKMzThtVr/hgf5FfUOj7+nCl8EARsp8oJ+Q6SwDhDrxMyEP+r0RPy+WlaoX9t7VNOC
         llRIBpGK6tQ1GrdjtW081wS+TpLpCLyYg/qvj4C0JAnTlwr0/QtIbSprwj7+MO4S7d
         h6byhmIWcZdfbOZzTEESvxHVQcl9rXmuxi5hq3HkhG5oMY0/tVZWe/Uw3lcG3Tc/QG
         TtFuJKiVDAwisMzTPzG0YlDePMN/CkoBZ8qh2L+ljj0ClNXh1RMpumcWP2GgOGWQSr
         jpyz2ShXwNNFg==
Date:   Tue, 10 May 2022 11:42:13 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@fb.com>
Cc:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220510184213.l3gjweeleyg7obca@treble>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
 <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 10, 2022 at 06:07:00PM +0000, Rik van Riel wrote:
> On Tue, 2022-05-10 at 09:52 -0700, Josh Poimboeuf wrote:
> > On Tue, May 10, 2022 at 04:07:42PM +0000, Rik van Riel wrote:
> > > > 
> > > Now I wonder if we could just hook up a preempt notifier
> > > for kernel live patches. All the distro kernels already
> > > need the preempt notifier for KVM, anyway...
> > > 
> > 
> > I wouldn't be opposed to that, but how does it solve this problem? 
> > If
> > as Peter said cond_resched() can be a NOP, then preemption would have
> > to
> > be from an interrupt, in which case frame pointers aren't reliable.
> > 
> The systems where we are seeing problems do not, as far
> as I know, throw softlockup errors, so the kworker
> threads that fail to transition to the new KLP version
> are sleeping and getting scheduled out at times.

Are they sleeping due to an explicit call to cond_resched()?

> A KLP transition preempt notifier would help those
> kernel threads transition to the new KLP version at
> any time they reschedule.

... unless cond_resched() is a no-op due to CONFIG_PREEMPT?

> How much it will help is hard to predict, but I should
> be able to get results from a fairly large sample size
> of systems within a few weeks :)

As Peter said, keep in mind that we will need to fix other cases beyond
Facebook, i.e., CONFIG_PREEMPT combined with non-x86 arches which don't
have ORC so they can't reliably unwind from an IRQ.

-- 
Josh
