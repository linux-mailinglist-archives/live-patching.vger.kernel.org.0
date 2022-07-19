Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C846157A69F
	for <lists+live-patching@lfdr.de>; Tue, 19 Jul 2022 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiGSSjp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 14:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbiGSSjo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 14:39:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5745A143;
        Tue, 19 Jul 2022 11:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 14FEDCE1D86;
        Tue, 19 Jul 2022 18:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB55C341C6;
        Tue, 19 Jul 2022 18:39:39 +0000 (UTC)
Date:   Tue, 19 Jul 2022 14:39:37 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Song Liu <song@kernel.org>
Cc:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>, <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 2/4] ftrace: allow IPMODIFY and DIRECT ops
 on the same function
Message-ID: <20220719143937.4ff4b167@gandalf.local.home>
In-Reply-To: <20220719142856.7d87ea6d@gandalf.local.home>
References: <20220718055449.3960512-1-song@kernel.org>
        <20220718055449.3960512-3-song@kernel.org>
        <20220719142856.7d87ea6d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 19 Jul 2022 14:28:56 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +				/* Cannot have two ipmodify on same rec */
> > +				if (is_ipmodify)
> > +					goto rollback;
> > +  
> 
> I might add a
> 
> 				FTRACE_WARN_ON(rec->flags &
> 				FTRACE_FL_DIRECT);

Bah, my email client line wrapped this. It was suppose to be:

 				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);

Just so you don't think I wanted that initial formatting ;-)

-- Steve

> 
> Just to be safe.
> 
> That is, if this is true, we are adding a new direct function to a record
> that already has one.

