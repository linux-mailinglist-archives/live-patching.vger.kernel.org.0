Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2986D7964
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 17:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733190AbfJOPHB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 11:07:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60112 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732939AbfJOPHB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 11:07:01 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B38672100;
        Tue, 15 Oct 2019 15:07:00 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2F8619C58;
        Tue, 15 Oct 2019 15:06:53 +0000 (UTC)
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
To:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
References: <20191007081945.10951536.8@infradead.org>
 <20191008104335.6fcd78c9@gandalf.local.home>
 <20191009224135.2dcf7767@oasis.local.home>
 <20191010092054.GR2311@hirez.programming.kicks-ass.net>
 <20191010091956.48fbcf42@gandalf.local.home>
 <20191010140513.GT2311@hirez.programming.kicks-ass.net>
 <20191010115449.22044b53@gandalf.local.home>
 <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
Date:   Tue, 15 Oct 2019 11:06:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 15 Oct 2019 15:07:00 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 10/15/19 10:13 AM, Miroslav Benes wrote:
> Yes, it does. klp_module_coming() calls module_disable_ro() on all
> patching modules which patch the coming module in order to call
> apply_relocate_add(). New (patching) code for a module can be relocated
> only when the relevant module is loaded.

FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ plumber's 
where livepatches only patch a single object and updates are kept on 
disk to handle coming module updates as they are loaded) eliminate those 
outstanding relocations and the need to perform this late permission 
flipping?

-- Joe
