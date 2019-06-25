Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F91055032
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2019 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729456AbfFYNYa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Jun 2019 09:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbfFYNYa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Jun 2019 09:24:30 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E21A3092669;
        Tue, 25 Jun 2019 13:24:22 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92ABC5C238;
        Tue, 25 Jun 2019 13:24:21 +0000 (UTC)
Subject: Re: [PATCH v4 00/10] klp-convert livepatch build tooling
To:     Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <alpine.LSU.2.21.1906131451560.22698@pobox.suse.cz>
 <b1a627a4-3702-9689-6c03-0c2123c06a2d@redhat.com>
 <c9021573-11c6-b576-0aa6-97754c98a06e@redhat.com>
 <20190614083435.uq3mk6mprbatysol@pathway.suse.cz>
 <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <76da6ab0-5540-d9ff-c5ea-6dc31a39c744@redhat.com>
Date:   Tue, 25 Jun 2019 09:24:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1906251324450.12085@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 25 Jun 2019 13:24:30 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/25/19 7:36 AM, Miroslav Benes wrote:
> 
 > [ ... snip ... ]
 >
> So I made a couple of experiments and found that GCC is somehow involved.
> If klp-convert (from scripts/livepatch/) is compiled with our GCC 4.8.5
> from SLE12, the output is incorrect. If I compile it with GCC 7.4.0 from
> openSUSE Leap 15.1, the output is correct.
> 
> If I revert commit d59cadc0a8f8 ("[squash] klp-convert: make
> convert_rela() list-safe") (from Joe's expanded github tree), the problem
> disappears.
> 
> I haven't spotted any problem in the code and I cannot explain a
> dependency on GCC version. Any ideas?
> 

Thanks for revisiting and debugging this.  Narrowing it down to my "fix" 
to convert_rela() should be helpful.

In my case, I was probably testing with RHEL-8, which has gcc 8.2 vs 
RHEL-7 which has gcc 4.8.  I'll have to make sure to try with a few 
different versions for the next round.

-- Joe
