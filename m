Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15D407705D
	for <lists+live-patching@lfdr.de>; Fri, 26 Jul 2019 19:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbfGZRin (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 26 Jul 2019 13:38:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51134 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387622AbfGZRin (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 26 Jul 2019 13:38:43 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA0B330C1E35;
        Fri, 26 Jul 2019 17:38:42 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D085F6061B;
        Fri, 26 Jul 2019 17:38:41 +0000 (UTC)
Subject: Re: [PATCH] kprobes: Allow kprobes coexist with livepatch
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
References: <156403587671.30117.5233558741694155985.stgit@devnote2>
 <20190726020752.GA6388@redhat.com>
 <20190726121449.22f0989e@gandalf.local.home>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <ddda9253-27df-755b-ed51-8abc2859f076@redhat.com>
Date:   Fri, 26 Jul 2019 13:38:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190726121449.22f0989e@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 26 Jul 2019 17:38:43 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/26/19 12:14 PM, Steven Rostedt wrote:
> On Thu, 25 Jul 2019 22:07:52 -0400
> Joe Lawrence <joe.lawrence@redhat.com> wrote:
> 
>> These results reflect my underestanding of FTRACE_OPS_FL_IPMODIFY in
>> light of your changes, so feel free to add my:
>>
>> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
> 
> Is this an urgent patch (needs to go in now and not wait for the next
> merge window) and if so, should it be marked for stable?
> 

Hi Steve,

IMHO, it's not urgent..  so unless Josh or other livepatch folks say 
otherwise, I'm ok with waiting for next merge window.  Given summer 
holiday schedules, that would give them more time to comment if they like.

Thanks,

-- Joe
