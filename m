Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCBBD8DA2
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 12:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404604AbfJPKPy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 06:15:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:50398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404606AbfJPKPx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 06:15:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E0F3DB266;
        Wed, 16 Oct 2019 10:15:51 +0000 (UTC)
Date:   Wed, 16 Oct 2019 12:15:50 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20191016074217.GL2328@hirez.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.1910161215020.7750@pobox.suse.cz>
References: <20191010115449.22044b53@gandalf.local.home> <20191010172819.GS2328@hirez.programming.kicks-ass.net> <20191011125903.GN2359@hirez.programming.kicks-ass.net> <20191015130739.GA23565@linux-8ccs> <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com> <20191015182705.1aeec284@gandalf.local.home>
 <20191016074217.GL2328@hirez.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 16 Oct 2019, Peter Zijlstra wrote:

> > which are not compatible with livepatching. GCC upstream now has
> > -flive-patching option, which disables all those interfering optimizations.
> 
> Which, IIRC, has a significant performance impact and should thus really
> not be used...

Fortunately, the impact is negligible.

Miroslav
