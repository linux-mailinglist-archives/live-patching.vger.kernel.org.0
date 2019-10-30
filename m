Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3C31E99AC
	for <lists+live-patching@lfdr.de>; Wed, 30 Oct 2019 11:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726091AbfJ3KFr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Oct 2019 06:05:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:44100 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbfJ3KFr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Oct 2019 06:05:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E742AADDA;
        Wed, 30 Oct 2019 10:05:45 +0000 (UTC)
Date:   Wed, 30 Oct 2019 11:05:45 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, jikos@kernel.org, pmladek@suse.com,
        nstange@suse.de, live-patching@vger.kernel.org
Subject: Re: [PATCH v2 3/3] s390/livepatch: Implement reliable stack tracing
 for the consistency model
In-Reply-To: <20191029161751.GH5646@osiris>
Message-ID: <alpine.LSU.2.21.1910301104230.18400@pobox.suse.cz>
References: <20191029143904.24051-1-mbenes@suse.cz> <20191029143904.24051-4-mbenes@suse.cz> <20191029161751.GH5646@osiris>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 29 Oct 2019, Heiko Carstens wrote:

> Hi Miroslav,
> 
> > +bool unwind_next_frame_reliable(struct unwind_state *state)
> > +{
> ...
> > +}
> > +
> >  void __unwind_start(struct unwind_state *state, struct task_struct *task,
> >  		    struct pt_regs *regs, unsigned long sp,
> >  		    bool unwind_reliable)
> 
> Did you send the wrong version of your patch series? This patch does
> not integrate your new function into the existing one. Also the new
> parameter you added with the second patch isn't used at all.

No, the version should be correct. Only __unwind_start_reliable() was 
integrated. The new parameter is used in arch_stack_walk_reliable() 
(unwind_reliable is set to true) and it is propagated to get_stack_info() 
where it is used to simplify things for the case.

Miroslav 

