Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D13F901EB
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2019 14:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfHPMrK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Aug 2019 08:47:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55916 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbfHPMrK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Aug 2019 08:47:10 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 76EBA804F2;
        Fri, 16 Aug 2019 12:47:10 +0000 (UTC)
Received: from [10.10.123.64] (ovpn-123-64.rdu2.redhat.com [10.10.123.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E817A8F6C4;
        Fri, 16 Aug 2019 12:47:09 +0000 (UTC)
Subject: Re: [PATCH v4 07/10] livepatch: Add sample livepatch module
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-8-joe.lawrence@redhat.com>
 <CAK7LNARmkRi1ug9C780egxUn1m1FMxAE+uN1d08hLNYZF1724Q@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <571e199e-c5a1-5863-ce50-675896c46a25@redhat.com>
Date:   Fri, 16 Aug 2019 08:47:09 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAK7LNARmkRi1ug9C780egxUn1m1FMxAE+uN1d08hLNYZF1724Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 16 Aug 2019 12:47:10 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/16/19 7:35 AM, Masahiro Yamada wrote:
> Hi Joe,
> 
> On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>> --- /dev/null
>> +++ b/samples/livepatch/livepatch-annotated-sample.c
>> @@ -0,0 +1,102 @@

> 
> Please use SPDX instead of the license boilerplate.
> 
> Thanks.
> 

Good eye, this revision was spun before ("treewide: Replace GPLv2 
boilerplate/reference with SPDX - rule 13"), so I will add this to the 
v5 TODO list.

Thanks,

-- Joe
