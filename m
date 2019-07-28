Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2AD78186
	for <lists+live-patching@lfdr.de>; Sun, 28 Jul 2019 22:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfG1UbA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 28 Jul 2019 16:31:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50608 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfG1UbA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 28 Jul 2019 16:31:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DA90D3B551;
        Sun, 28 Jul 2019 20:30:59 +0000 (UTC)
Received: from treble (ovpn-120-102.rdu2.redhat.com [10.10.120.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0705C5D70D;
        Sun, 28 Jul 2019 20:30:55 +0000 (UTC)
Date:   Sun, 28 Jul 2019 15:30:53 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] s390/livepatch: Implement reliable stack tracing for the
 consistency model
Message-ID: <20190728203053.q3pafkwnzm5j3ccs@treble>
References: <20190710105918.22487-1-mbenes@suse.cz>
 <20190716184549.GA26084@redhat.com>
 <alpine.LSU.2.21.1907171223540.4492@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1907171223540.4492@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Sun, 28 Jul 2019 20:31:00 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 17, 2019 at 01:01:27PM +0200, Miroslav Benes wrote:
> > On a related note, do you think it would be feasible to extend (in
> > another patchset) the reliable stack unwinding code a bit so that we
> > could feed it pre-baked stacks ... then we could verify that the code
> > was finding interesting scenarios.  That was a passing thought I had
> > back when Nicolai and I were debugging the ppc64le exception frame
> > marker bug, but didn't think it worth the time/effort at the time.
> 
> That is an interesting thought. It would help the testing a lot. I will 
> make a note in my todo list.

Another idea I had for reliable unwinder testing: add a
CONFIG_RELIABLE_STACKTRACE_DEBUG option which does a periodic stack
trace and warns if it doesn't reach the end.  It could triggered from a
periodic NMI, or from schedule().

-- 
Josh
