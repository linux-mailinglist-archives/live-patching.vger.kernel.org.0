Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1BA31729
	for <lists+live-patching@lfdr.de>; Sat,  1 Jun 2019 00:25:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfEaWZh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 31 May 2019 18:25:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbfEaWZh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 31 May 2019 18:25:37 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0D2BC90901;
        Fri, 31 May 2019 22:25:37 +0000 (UTC)
Received: from treble (ovpn-124-142.rdu2.redhat.com [10.10.124.142])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC42C60FB4;
        Fri, 31 May 2019 22:25:29 +0000 (UTC)
Date:   Fri, 31 May 2019 17:25:27 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] livepatch: Fix ftrace module text permissions race
Message-ID: <20190531222527.535zt6qzqmad34ss@treble>
References: <bb69d4ac34111bbd9cb16180a6fafe471a88d80b.1559156299.git.jpoimboe@redhat.com>
 <20190530135414.taftuprranwtowry@pathway.suse.cz>
 <20190531191256.z5fm4itxewagd5xc@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190531191256.z5fm4itxewagd5xc@treble>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Fri, 31 May 2019 22:25:37 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 31, 2019 at 02:12:56PM -0500, Josh Poimboeuf wrote:
> > Anyway, the above is a separate problem. This patch looks
> > fine for the original problem.
> 
> Thanks for the review.  I'll post another version, with the above
> changes and with the patches split up like Miroslav suggested.

The latest patches are here:

  https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git/log/?h=fix-livepatch-ftrace-race

If the bot likes them, I'll post them properly soon.

-- 
Josh
