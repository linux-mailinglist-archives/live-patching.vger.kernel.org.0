Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F671AA4CC
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 15:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfIENms (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 09:42:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfIENms (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 09:42:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4FAB9307D976;
        Thu,  5 Sep 2019 13:42:48 +0000 (UTC)
Received: from treble (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE3E75DAAC;
        Thu,  5 Sep 2019 13:42:41 +0000 (UTC)
Date:   Thu, 5 Sep 2019 08:42:39 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905134239.fmoknq3z422tflst@treble>
References: <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
 <nycvar.YFH.7.76.1909051317550.31470@cbobk.fhfr.pm>
 <20190905132344.byfybt6s42cajtfz@treble>
 <nycvar.YFH.7.76.1909051531020.31470@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.1909051531020.31470@cbobk.fhfr.pm>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 05 Sep 2019 13:42:48 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 03:31:56PM +0200, Jiri Kosina wrote:
> On Thu, 5 Sep 2019, Josh Poimboeuf wrote:
> 
> > > All the indirect jumps are turned into alternatives when retpolines 
> > > are in place.
> > 
> > Actually in C code those are done by the compiler as calls/jumps to
> > __x86_indirect_thunk_*.
> 
> Sure, and the thunks do the redirection via JMP_NOSPEC / CALL_NOSPEC, 
> which has alternative in it.

But the thunks are isolated to arch/x86/lib/retpoline.S.  We can't patch
that code anyway.

-- 
Josh
