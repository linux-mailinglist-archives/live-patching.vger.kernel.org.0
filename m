Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB135A098
	for <lists+live-patching@lfdr.de>; Fri,  9 Apr 2021 16:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhDIODA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Apr 2021 10:03:00 -0400
Received: from linux.microsoft.com ([13.77.154.182]:55314 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232796AbhDIOC4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Apr 2021 10:02:56 -0400
Received: from [192.168.254.32] (unknown [47.187.194.202])
        by linux.microsoft.com (Postfix) with ESMTPSA id 865BD20B5680;
        Fri,  9 Apr 2021 07:02:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 865BD20B5680
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1617976963;
        bh=GxI9MmdzWGr7nnktck4TyPxKLYohdw0uB9LcCzDuPYk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dIQln+/Qcl4vYhj0bP0wGn34Tk4kn6mA+wTTbm9ObqpkZxVOiBHjDVmG1KKlx5bfz
         YlXt1Yje46hQl+RYZ3wLCy0olo3P+p/slmv7ww0lakcHCxc2acqvqGE6dctSWa5IWe
         5yZOW1xBL2Orb7sVzh5JHTr1zdEXH1QzKt7TIB8Y=
Subject: Re: [RFC PATCH v2 3/4] arm64: Detect FTRACE cases that make the stack
 trace unreliable
To:     Mark Brown <broonie@kernel.org>
Cc:     mark.rutland@arm.com, jpoimboe@redhat.com, jthierry@redhat.com,
        catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <705993ccb34a611c75cdae0a8cb1b40f9b218ebd>
 <20210405204313.21346-1-madvenka@linux.microsoft.com>
 <20210405204313.21346-4-madvenka@linux.microsoft.com>
 <20210408165825.GP4516@sirena.org.uk>
 <eacc6098-a15f-c07a-2730-cb16cb8e1982@linux.microsoft.com>
 <20210409113101.GA4499@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <75944f33-9a3e-27d9-75df-b2038c10ea02@linux.microsoft.com>
Date:   Fri, 9 Apr 2021 09:02:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409113101.GA4499@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 4/9/21 6:31 AM, Mark Brown wrote:
> On Thu, Apr 08, 2021 at 02:23:39PM -0500, Madhavan T. Venkataraman wrote:
>> On 4/8/21 11:58 AM, Mark Brown wrote:
> 
>>> This looks good to me however I'd really like someone who has a firmer
>>> understanding of what ftrace is doing to double check as it is entirely
>>> likely that I am missing cases here, it seems likely that if I am
>>> missing stuff it's extra stuff that needs to be added and we're not
>>> actually making use of the reliability information yet.
> 
>> OK. So, do you have some specific reviewer(s) in mind? Apart from yourself, Mark Rutland and
>> Josh Poimboeuf, these are some reviewers I can think of (in alphabetical order):
> 
> Mainly Mark Rutland, but generally someone else who has looked at ftrace
> on arm64 in detail.  It was mainly a comment to say I wasn't going to do
> any kind of Reviewed-by but also hadn't spotted any issues.
> 

Understood.

Madhavan
