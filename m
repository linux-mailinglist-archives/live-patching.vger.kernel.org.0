Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B34DB450F5
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 02:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbfFNA5d (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 13 Jun 2019 20:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbfFNA5d (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 13 Jun 2019 20:57:33 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7753B3091740;
        Fri, 14 Jun 2019 00:57:20 +0000 (UTC)
Received: from treble (ovpn-121-232.rdu2.redhat.com [10.10.121.232])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E9EC607AF;
        Fri, 14 Jun 2019 00:57:14 +0000 (UTC)
Date:   Thu, 13 Jun 2019 19:57:07 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] livepatch: Fix ftrace module text permissions race
Message-ID: <20190614005707.oq5ndrhropbbkoq7@treble>
References: <bb69d4ac34111bbd9cb16180a6fafe471a88d80b.1559156299.git.jpoimboe@redhat.com>
 <20190530135414.taftuprranwtowry@pathway.suse.cz>
 <20190531191256.z5fm4itxewagd5xc@treble>
 <20190531222527.535zt6qzqmad34ss@treble>
 <20190613173804.37cd37f8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190613173804.37cd37f8@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 14 Jun 2019 00:57:33 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 13, 2019 at 05:38:04PM -0400, Steven Rostedt wrote:
> On Fri, 31 May 2019 17:25:27 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > On Fri, May 31, 2019 at 02:12:56PM -0500, Josh Poimboeuf wrote:
> > > > Anyway, the above is a separate problem. This patch looks
> > > > fine for the original problem.  
> > > 
> > > Thanks for the review.  I'll post another version, with the above
> > > changes and with the patches split up like Miroslav suggested.  
> > 
> > The latest patches are here:
> > 
> >   https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git/log/?h=fix-livepatch-ftrace-race
> > 
> > If the bot likes them, I'll post them properly soon.
> > 
> 
> Was this ever posted?

I totally forgot.  I'll post them now.

-- 
Josh
